# - Try to find Libfacile
# Once done this will define
#
#  LIBFACILE_FOUND - system has Libfacile
#  LIBFACILE_INCLUDE_DIR - the Libfacile include directory
#  LIBFACILE_LIBRARIES - Link these to use Libfacile
#
# Copyright (c) 2006, Carsten Niehaus, <cniehaus@gmx.de>
# Copyright (c) 2006, Montel Laurent, <montel@kde.org>
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


find_package(OCaml)

if( OCAML_FOUND )
   find_library(LIBFACILE_LIBRARIES NAMES facile.a
       HINTS ${OCAMLC_DIR}
       PATH_SUFFIXES facile ocaml/facile
   )
   find_path(LIBFACILE_INCLUDE_DIR NAMES facile.cmi
       HINTS ${OCAMLC_DIR}
       PATH_SUFFIXES facile lib/ocaml/facile
   )
endif(OCAML_FOUND)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Libfacile DEFAULT_MSG LIBFACILE_INCLUDE_DIR
	LIBFACILE_LIBRARIES OCAML_FOUND)

# show the LIBFACILE_INCLUDE_DIR and LIBFACILE_LIBRARIES variables only in the advanced view
mark_as_advanced(LIBFACILE_INCLUDE_DIR LIBFACILE_LIBRARIES )
