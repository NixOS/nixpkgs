# cmake macro to test msiLBC

# Copyright (c) 2009-2010 Pali Rohár <pali.rohar@gmail.com>
#
# MSILBC_FOUND
# MSILBC_LIBRARY

include ( FindPackageHandleStandardArgs )

if ( MSILBC_LIBRARY )
	set ( MSILBC_FOUND true )
	set ( msiLBC_FIND_QUIETLY true )
else ( MSILBC_LIBRARY )
	find_library ( MSILBC_LIBRARY NAMES msilbc
		PATH_SUFFIXES mediastreamer/plugins)
endif ( MSILBC_LIBRARY )

find_package_handle_standard_args ( msiLBC DEFAULT_MSG MSILBC_LIBRARY )
mark_as_advanced ( MSILBC_LIBRARY )
