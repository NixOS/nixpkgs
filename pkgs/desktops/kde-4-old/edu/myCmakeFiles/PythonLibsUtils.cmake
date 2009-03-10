SET(PYTHON_KNOWN_VERSIONS "2.5" "2.4" "2.3" "2.2" "2.1" "2.0" "1.6" "1.5")

MACRO(python_find_version _py_ver _py_inc _py_ld _py_lib)
	STRING(REPLACE "." "" _py_ver_nd "${_py_ver}")

	SET(PY_INSTALL_PATH
		[HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\${_py_ver}\\InstallPath])

	SET(_py_libnames "python${_py_ver}" "python${_py_ver_nd}")

	SET(_py_found FALSE)
	FOREACH(_py_libname ${_py_libnames})
		IF (NOT _py_found)
			SET(_py_lib_full _py_lib_full-NOTFOUND)

			FIND_LIBRARY(_py_lib_full
				NAMES "${_py_libname}"
				PATHS "${PY_INSTALL_PATH}/libs"
				NO_SYSTEM_ENVIRONMENT_PATH
			)
			FIND_LIBRARY(_py_lib_full
				NAMES "${_py_libname}"
				PATHS "${PY_INSTALL_PATH}/libs"
				PATH_SUFFIXES "python${_py_ver}/config"
				NO_SYSTEM_ENVIRONMENT_PATH
			)
			IF(_py_lib_full)
				SET(_py_lib "${_py_libname}")
				GET_FILENAME_COMPONENT(_py_ld "${_py_lib_full}" PATH)
				SET(_py_found TRUE)
			ENDIF(_py_lib_full)
		ENDIF(NOT _py_found)
	ENDFOREACH(_py_libname)

	IF(_py_found)
		FIND_PATH(_py_inc
			NAMES Python.h
			PATHS
				${PY_INSTALL_PATH}/include
			PATH_SUFFIXES
				"python${_py_ver}"
		)
	ENDIF(_py_found)

	SET(PYTHON_REQ_VERSION_FOUND ${_py_found})
ENDMACRO(python_find_version)
