# Try to find the IlmBase libraries
# This check defines:
#
#  ILMBASE_FOUND - system has IlmBase
#  ILMBASE_INCLUDE_DIR - IlmBase include directory
#  ILMBASE_LIBRARIES - Libraries needed to use IlmBase
#
# Copyright (c) 2006, Alexander Neundorf, <neundorf@kde.org>
# Copyright (c) 2007, Yury G. Kudryashov, <urkud.urkud@gmail.com>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

if (ILMBASE_INCLUDE_DIR AND ILMBASE_LIBRARIES)
  # in cache already
  SET(ILMBASE_FOUND TRUE)

else (ILMBASE_INCLUDE_DIR AND ILMBASE_LIBRARIES)
IF (NOT WIN32)
  # use pkg-config to get the directories and then use these values
  # in the FIND_PATH() and FIND_LIBRARY() calls
  INCLUDE(UsePkgConfig)
  
  PKGCONFIG(IlmBase _IlmBaseIncDir _IlmBaseLinkDir _IlmBaseLinkFlags _IlmBaseCflags)
ENDIF (NOT WIN32)  
  FIND_PATH(ILMBASE_INCLUDE_DIR ImathBox.h
     ${_IlmBaseIncDir}
     ${_IlmBaseIncDir}/OpenEXR/
  )

  FIND_LIBRARY(ILMBASE_HALF_LIBRARY NAMES Half
    PATHS
    ${_IlmBaseLinkDir}
    NO_DEFAULT_PATH
  )
  FIND_LIBRARY(ILMBASE_HALF_LIBRARY NAMES Half )
  
  FIND_LIBRARY(ILMBASE_IEX_LIBRARY NAMES Iex
    PATHS
    ${_IlmBaseLinkDir}
    NO_DEFAULT_PATH
  )
  FIND_LIBRARY(ILMBASE_IEX_LIBRARY NAMES Iex )
  
  FIND_LIBRARY(ILMBASE_IMATH_LIBRARY NAMES Imath
    PATHS
    ${_IlmBaseLinkDir}
    NO_DEFAULT_PATH
  )
  FIND_LIBRARY(ILMBASE_IMATH_LIBRARY NAMES Imath )  
  
  if (ILMBASE_INCLUDE_DIR AND ILMBASE_IMATH_LIBRARY AND ILMBASE_IEX_LIBRARY AND ILMBASE_HALF_LIBRARY)
     set(ILMBASE_FOUND TRUE)
     set(ILMBASE_LIBRARIES ${ILMBASE_IMATH_LIBRARY} ${ILMBASE_IEX_LIBRARY} ${ILMBASE_HALF_LIBRARY} CACHE STRING "The libraries needed to use IlmBase")
  endif (ILMBASE_INCLUDE_DIR AND ILMBASE_IMATH_LIBRARY AND ILMBASE_IEX_LIBRARY AND ILMBASE_HALF_LIBRARY)
  
  if (ILMBASE_FOUND)
    if (NOT IlmBase_FIND_QUIETLY)
      message(STATUS "Found ILMBASE: ${ILMBASE_LIBRARIES}")
    endif (NOT IlmBase_FIND_QUIETLY)
  else (ILMBASE_FOUND)
    if (IlmBase_FIND_REQUIRED)
      message(FATAL_ERROR "Could NOT find ILMBASE")
    endif (IlmBase_FIND_REQUIRED)
  endif (ILMBASE_FOUND)
  
  MARK_AS_ADVANCED(
     ILMBASE_INCLUDE_DIR 
     ILMBASE_LIBRARIES 
     ILMBASE_IMATH_LIBRARY 
     ILMBASE_IEX_LIBRARY 
     ILMBASE_HALF_LIBRARY )
  
endif (ILMBASE_INCLUDE_DIR AND ILMBASE_LIBRARIES)
