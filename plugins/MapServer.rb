##
# This file is part of WhatWeb and may be subject to
# redistribution and commercial restrictions. Please see the WhatWeb
# web site for more information on licensing and terms of use.
# http://www.morningstarsecurity.com/research/whatweb
##
# Version 0.2 # 2011-07-30 # Brendan Coles <bcoles@gmail.com>
# Added examples URLs, added passive match and added google dork
##
# Version 0.3 Andrew Horton. Replaced aggressive function with matches

Plugin.define "MapServer" do
author "Aung Khant, http://yehg.net"
version "0.3"
description "Detect MapServer CGI application (http://www.mapserver.org/)"

# Google results as at 2011-07-30 #
# 210 for inurl:cgi-bin/mapserv/?map
# 133 for inurl:"cgi-bin/mapserv/?map"
#  80 for inurl:"cgi-bin/mapserv.exe/?map"

# Dorks #
dorks [
'inurl:cgi-bin/mapserv/?map'
]

# Examples #
examples %w|
demo.mapserver.org/cgi-bin/mapserv
ide.jccm.es/cgi-bin/mapserv
gis11.nsgc.gov.ns.ca/cgi-bin/mapserv.exe
mrdata.usgs.gov/cgi-bin/mapserv
cwcgom.aoml.noaa.gov/cgi-bin/mapserv
biometry.gis.umn.edu/cgi-bin/mapserv.exe
bg.berkeley.edu/cgi-bin/mapserv
niceguy.wustl.edu/cgi-bin/mapserv
water.umn.edu/cgi-bin/mapserv-3
relief.ersc.wisc.edu/cgi-bin/mapserv
mesonet.agron.iastate.edu/cgi-bin/mapserv/mapserv
planet.sr.unh.edu/cgi-bin/mapserv
|			

matches [
 {:name=>"Version", :url=>"?map=*", :version=>/<\/HEAD>\s*<!\-\- MapServer version (.*?)\s/ },
 {:name => "Invalid Map Parameter", :url=>"/cgi-bin/mapserv/?map=*", :regexp=>/<BODY BGCOLOR="#FFFFFF">\s*msLoadMap(): Regular expression error/},
 {:name => "Invalid Map Parameter", :url=>"/cgi-bin/mapserv/?map=*", :regexp=>/<HEAD><TITLE>MapServer Message<\/TITLE><\/HEAD>\s*<!\-\- MapServer version/}
]

# Passive #
def passive
	m=[]
	# Error Message # Empty QUERY_STRING
	if @body == "No query information to decode. QUERY_STRING is set, but empty.\n"
		m << { :name=>"Error Message" }
	end
	# Return passive matches
	m
end

end

