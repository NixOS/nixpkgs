# Try to find the OpenEXR libraries
# This check defines:
#
#  OPENEXR_FOUND - system has OpenEXR
#  OPENEXR_INCLUDE_DIR - OpenEXR include directory
#  OPENEXR_LIBRARIES - Libraries needed to use OpenEXR
#
# Copyright (c) 2006, Alexander Neundorf, <neundorf@kde.org>
# Copyright (c) 2007, Yury G. Kudryashov, <urkud.urkud@gmail.com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


if (OPENEXR_INCLUDE_DIR AND OPENEXR_LIBRARIES)
  # in cache already
  SET(OPENEXR_FOUND TRUE)

else (OPENEXR_INCLUDE_DIR AND OPENEXR_LIBRARIES)
FIND_PACKAGE(IlmBase)
IF (NOT ILMBASE_FOUND)
	SET(OPENEXR_FOUND FALSE)
ELSE (NOT ILMBASE_FOUND)
IF (NOT WIN32)
  # use pkg-config to get the directories and then use these values
  # in the FIND_PATH() and FIND_LIBRARY() calls
  INCLUDE(UsePkgConfig)
  
  PKGCONFIG(OpenEXR _OpenEXRIncDir _OpenEXRLinkDir _OpenEXRLinkFlags _OpenEXRCflags)
ENDIF (NOT WIN32)  
  FIND_PATH(OPENEXR_INCLUDE_DIR ImfRgbaFile.h
     ${_OpenEXRIncDir}
     ${_OpenEXRIncDir}/OpenEXR/
  )

  FIND_LIBRARY(OPENEXR_ILMIMF_LIBRARY NAMES IlmImf 
    PATHS
    ${_OpenEXRLinkDir}
    NO_DEFAULT_PATH
  )
  FIND_LIBRARY(OPENEXR_ILMIMF_LIBRARY NAMES IlmImf )  
  
  if (OPENEXR_INCLUDE_DIR AND OPENEXR_ILMIMF_LIBRARY)
     set(OPENEXR_FOUND TRUE)
     set(OPENEXR_LIBRARIES ${ILMBASE_LIBRARIES} ${OPENEXR_ILMIMF_LIBRARY} CACHE STRING "The libraries needed to use OpenEXR")
	 set(OPENEXR_INCLUDE_DIR ${OPENEXR_INCLUDE_DIR} ${ILMBASE_INCLUDE_DIR})
  endif (OPENEXR_INCLUDE_DIR AND OPENEXR_ILMIMF_LIBRARY)
ENDIF (NOT ILMBASE_FOUND)
  
  if (OPENEXR_FOUND)
    if (NOT OpenEXR_FIND_QUIETLY)
      message(STATUS "Found OPENEXR: ${OPENEXR_LIBRARIES}")
    endif (NOT OpenEXR_FIND_QUIETLY)
  else (OPENEXR_FOUND)
    if (OpenEXR_FIND_REQUIRED)
      message(FATAL_ERROR "Could NOT find OPENEXR")
    endif (OpenEXR_FIND_REQUIRED)
  endif (OPENEXR_FOUND)
  
  MARK_AS_ADVANCED(
     OPENEXR_INCLUDE_DIR 
     OPENEXR_LIBRARIES 
     OPENEXR_ILMIMF_LIBRARY 
     OPENEXR_IMATH_LIBRARY 
     OPENEXR_IEX_LIBRARY 
     OPENEXR_HALF_LIBRARY )
  
endif (OPENEXR_INCLUDE_DIR AND OPENEXR_LIBRARIES)
