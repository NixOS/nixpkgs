include(CheckCXXSourceCompiles)
include(CheckIncludeFileCXX)
include(CheckLibraryExists)

MACRO(check_boost_and_python_compatible
	_bo_inc _bo_ld _bo_py_lib
	_py_inc _py_ld _py_lib)

	set(_save_CXX_FLAGS ${CMAKE_CXX_FLAGS})
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${KDE4_ENABLE_EXCEPTIONS}")

	set(CMAKE_REQUIRED_FLAGS "-L${_bo_ld} -L${_py_ld}")
	set(CMAKE_REQUIRED_INCLUDES ${_py_inc} ${_bo_inc})
	set(CMAKE_REQUIRED_LIBRARIES ${_bo_py_lib} ${_py_lib})

	check_cxx_source_compiles("
#include <boost/python.hpp>
const char* greet() { return \"Hello world!\"; }
BOOST_PYTHON_MODULE(hello) { boost::python::def(\"greet\", greet); }

int main() { return 0; }

// some vars, in case of the compilation fail...
// python include dir: ${_py_inc}
// python lib: ${_py_lib}
// 
// boost python lib: ${_bo_py_lib}
// boost include dir: ${_bo_inc}
// boost lib dir: ${_bo_ld}
// 
"
BOOST_PYTHON_${_bo_inc}_${_bo_ld}_${_bo_py_lib}_${_py_inc}_${_py_ld}_${_py_lib}_COMPATIBLE )

	set(CMAKE_REQUIRED_FLAGS)
	set(CMAKE_REQUIRED_INCLUDES)
	set(CMAKE_REQUIRED_LIBRARIES)
	set(CMAKE_CXX_FLAGS ${_save_CXX_FLAGS})
ENDMACRO(check_boost_and_python_compatible)
