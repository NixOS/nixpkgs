# - Try to find the a valid boost+python combination
# Once done this will define
#
#  Boost_PYTHON_FOUND - system has a valid boost+python combination
#  BOOST_PYTHON_INCLUDES - the include directory for boost+python
#  BOOST_PYTHON_LIBS - the needed libs for boost+python

# Copyright (c) 2006, Pino Toscano, <toscano.pino@tiscali.it>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.

if(BOOST_PYTHON_INCLUDES AND BOOST_PYTHON_LIBS)
	# Already in cache, be silent
	set(Boost_PYTHON_FIND_QUIETLY TRUE)
endif(BOOST_PYTHON_INCLUDES AND BOOST_PYTHON_LIBS)

SET(Boost_PYTHON_LIB_SUFFIXES "-mt" "-gcc-mt")
SET(Boost_KNOWN_VERSIONS "-1_34_1" "-1_34_0" "-1_33_1" "-1_33_0")

FIND_PACKAGE(Boost)
INCLUDE(PythonLibsUtils)
INCLUDE(CheckBoostAndPythonCompatible)

IF(Boost_FOUND AND Boost_LIBRARY_DIRS)

	SET(Boost_PYTHON_LIB_NAMES boost_python)
	FOREACH(_suffix ${Boost_PYTHON_LIB_SUFFIXES})
		set(Boost_PYTHON_LIB_NAMES ${Boost_PYTHON_LIB_NAMES}
			boost_python${_suffix})
		FOREACH(_bo_ver ${Boost_KNOWN_VERSIONS})
			set(Boost_PYTHON_LIB_NAMES ${Boost_PYTHON_LIB_NAMES}
				boost_python${_suffix}${_bo_ver})
		ENDFOREACH(_bo_ver)
	ENDFOREACH(_suffix)

	SET(_found FALSE)
	FOREACH(_boost_python_lib ${Boost_PYTHON_LIB_NAMES})
		IF(NOT _found)
			FIND_LIBRARY(Boost_PYTHON_LIB_FULLPATH
				NAME ${_boost_python_lib}
				PATHS ${Boost_LIBRARY_DIRS}
				NO_DEFAULT_PATH
				)
			IF(Boost_PYTHON_LIB_FULLPATH)
				SET(Boost_PYTHON_LIB ${_boost_python_lib})
				SET(_found TRUE)
			ENDIF(Boost_PYTHON_LIB_FULLPATH)
		ENDIF(NOT _found)
	ENDFOREACH(_boost_python_lib)

	IF(Boost_PYTHON_LIB)
		SET(_found FALSE)
		FOREACH(_py_ver ${PYTHON_KNOWN_VERSIONS})
			if (NOT _found)
				python_find_version(${_py_ver} _py_inc _py_ld _py_lib)
				IF(PYTHON_REQ_VERSION_FOUND)
					MESSAGE(STATUS " ${Boost_INCLUDE_DIRS} ${Boost_LIBRARY_DIRS} ${Boost_PYTHON_LIB} ${_py_inc} ${_py_ld} ${_py_lib}")
					check_boost_and_python_compatible(
						"${Boost_INCLUDE_DIRS}" "${Boost_LIBRARY_DIRS}"
						"${Boost_PYTHON_LIB}" "${_py_inc}" "${_py_ld}"
						"${_py_lib}")
					SET(_found
						BOOST_PYTHON_${Boost_INCLUDE_DIRS}_${Boost_LIBRARY_DIRS}_${Boost_PYTHON_LIB}_${_py_inc}_${_py_ld}_${_py_lib}_COMPATIBLE)

					IF(BOOST_PYTHON_${Boost_INCLUDE_DIRS}_${Boost_LIBRARY_DIRS}_${Boost_PYTHON_LIB}_${_py_inc}_${_py_ld}_${_py_lib}_COMPATIBLE)
						SET(BOOST_PYTHON_INCLUDES ${Boost_INCLUDE_DIRS} ${_py_inc})
						SET(BOOST_PYTHON_LIBS "-l${_py_lib} -L${_py_ld} -l${Boost_PYTHON_LIB}")
						SET(BOOST_PYTHON_FOUND TRUE)
						SET(_found TRUE)
					ENDIF(BOOST_PYTHON_${Boost_INCLUDE_DIRS}_${Boost_LIBRARY_DIRS}_${Boost_PYTHON_LIB}_${_py_inc}_${_py_ld}_${_py_lib}_COMPATIBLE)
				ENDIF(PYTHON_REQ_VERSION_FOUND)
			ENDIF(NOT _found)
		ENDFOREACH(_py_ver)
	ENDIF(Boost_PYTHON_LIB)
ENDIF(Boost_FOUND AND Boost_LIBRARY_DIRS)

if(BOOST_PYTHON_FOUND)
	if(NOT BoostPython_FIND_QUIETLY)
		message(STATUS "Found Boost+Python: ${BOOST_PYTHON_INCLUDES} ${BOOST_PYTHON_LIBS}")
	endif(NOT BoostPython_FIND_QUIETLY)
	set(KIG_ENABLE_PYTHON_SCRIPTING 1)
else (BOOST_PYTHON_FOUND)
	if (BoostPython_FIND_REQUIRED)
		message(FATAL_ERROR "Could NOT find Boost+Python")
	endif(BoostPython_FIND_REQUIRED)
	set(KIG_ENABLE_PYTHON_SCRIPTING 0)
endif(BOOST_PYTHON_FOUND)

mark_as_advanced(BOOST_PYTHON_INCLUDES BOOST_PYTHON_LIBS)
