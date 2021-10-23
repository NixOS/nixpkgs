# based on qtbase/cmake/FindMySQL.cmake
# based on cmake-3.21.2/share/cmake-3.21/Modules/FindOpenGL.cmake

#.rst:
# FindOpenVG
# ---------
#
# Try to locate an openvg library.
# If found, this will define the following variables:
#
# ``OpenVG_FOUND``
#     True if the mysql library is available
# ``OpenVG_INCLUDE_DIRS``
#     The mysql include directories
# ``OpenVG_LIBRARIES``
#     The mysql libraries for linking
#
# If ``OpenVG_FOUND`` is TRUE, it will also define the following
# imported target:
#
# ``OpenVG::OpenVG``
#     The openvg library



# CMake module to search for the ShivaVG library
#
# If cmake finds ShivaVG, it will set the variables
#
#    SHIVAVG_FOUND
#    SHIVAVG_INCLUDE_DIR
#    SHIVAVG_LIBRARIES
#
FIND_PATH(SHIVAVG_INCLUDE_DIR NAMES VG/vgu.h VG/openvg.h)
FIND_LIBRARY(SHIVAVG_LIBRARIES NAMES ShivaVG libShivaVG)
if (SHIVAVG_INCLUDE_DIR AND SHIVAVG_LIBRARIES)
  set(SHIVAVG_FOUND 1)
endif()



# choose implementation
# TODO allow the user to set a preference
# similar to libGL vs libglvnd in FindOpenGL.cmake

if (SHIVAVG_FOUND)
  set(OpenVG_FOUND 1)
  set(OpenVG_INCLUDE_DIR $SHIVAVG_INCLUDE_DIRS)
  set(OpenVG_LIBRARY $SHIVAVG_LIBRARIES)

elseif(MONKVG_FOUND)
  message(FATAL_ERROR "TODO implement MONKVG_FOUND")
  set(OpenVG_FOUND 1)

elseif(AMANITHVG_FOUND)
  message(FATAL_ERROR "TODO implement AMANITHVG_FOUND")
  set(OpenVG_FOUND 1)

else()
  set(OpenVG_FOUND 0)

endif()




if(OpenVG_FOUND)
  set(OpenVG_INCLUDE_DIRS "${OpenVG_INCLUDE_DIR}")
  set(OpenVG_LIBRARIES "${OpenVG_LIBRARY}")
  if(NOT TARGET OpenVG::OpenVG)
    add_library(OpenVG::OpenVG UNKNOWN IMPORTED)
    set_target_properties(OpenVG::OpenVG PROPERTIES
                          IMPORTED_LOCATION "${OpenVG_LIBRARIES}"
                          INTERFACE_INCLUDE_DIRECTORIES "${OpenVG_INCLUDE_DIRS}")
  endif()
endif()

mark_as_advanced(OpenVG_INCLUDE_DIR OpenVG_LIBRARY)

include(FeatureSummary)
#set_package_properties(OpenVG PROPERTIES
#  #URL "https://www.mysql.com"
#  DESCRIPTION "OpenVG client library")
