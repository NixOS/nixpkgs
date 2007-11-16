# - Try to find Libfacile
# Once done this will define
#
#  LIBFACILE_FOUND - system has Libfacile
#  LIBFACILE_INCLUDE_DIR - the Libfacile include directory
#  LIBFACILE_LIBRARIES - Link these to use Libfacile
#  LIBFACILE_DEFINITIONS - Compiler switches required for using Libfacile
#
# Copyright (c) 2006, Carsten Niehaus, <cniehaus@gmx.de>
# Copyright (c) 2006, Montel Laurent, <montel@kde.org>
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


find_package(OCaml)

set(LIBFACILE_FOUND FALSE)

if( OCAML_FOUND )
   find_file(LIBFACILE_LIBRARIES NAME facile.a
       PATHS ${OCAMLC_DIR} ENV CMAKE_LIBRARY_PATH
	   PATH_SUFFIXES facile ocaml/facile
   )
   message(STATUS "LIBFACILE_LIBRARIES :<${LIBFACILE_LIBRARIES}>") 
   if (LIBFACILE_LIBRARIES)
	   get_filename_component(LIBFACILE_INCLUDE_DIR ${LIBFACILE_LIBRARIES} PATH)
	   message(STATUS "LIBFACILE_INCLUDE_DIR <${LIBFACILE_INCLUDE_DIR}>")
       set(LIBFACILE_FOUND TRUE)
   endif(LIBFACILE_LIBRARIES)
endif(OCAML_FOUND)


if(LIBFACILE_FOUND)
   if(NOT Libfacile_FIND_QUIETLY)
      message(STATUS "Found Libfacile: ${LIBFACILE_LIBRARIES}")
   endif(NOT Libfacile_FIND_QUIETLY)
else(LIBFACILE_FOUND)
   if(Libfacile_FIND_REQUIRED)
      message(FATAL_ERROR "Could not find Libfacile")
   endif(Libfacile_FIND_REQUIRED)
endif(LIBFACILE_FOUND)

# show the LIBFACILE_INCLUDE_DIR and LIBFACILE_LIBRARIES variables only in the advanced view
mark_as_advanced(LIBFACILE_INCLUDE_DIR LIBFACILE_LIBRARIES )
 
