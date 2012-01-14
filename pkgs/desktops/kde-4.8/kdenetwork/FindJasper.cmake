# - Try to find the Jasper JPEG2000 library
# Once done this will define
#
#  JASPER_FOUND - system has Jasper
#  JASPER_INCLUDE_DIR - the Jasper include directory
#  JASPER_LIBRARIES - The libraries needed to use Jasper

#=============================================================================
# Copyright 2006-2009 Kitware, Inc.
# Copyright 2006 Alexander Neundorf <neundorf@kde.org>
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of CMake, substitute the full
#  License text for the above reference.)

FIND_PACKAGE(JPEG)

FIND_PATH(JASPER_INCLUDE_DIR jasper/jasper.h)

FIND_LIBRARY(JASPER_LIBRARY NAMES jasper libjasper)

SET(JASPER_LIBRARIES ${JASPER_LIBRARY})

# handle the QUIETLY and REQUIRED arguments and set JASPER_FOUND to TRUE if 
# all listed variables are TRUE
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(Jasper DEFAULT_MSG JASPER_LIBRARIES JASPER_INCLUDE_DIR)

MARK_AS_ADVANCED(JASPER_INCLUDE_DIR JASPER_LIBRARY)
