find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
  pkg_check_modules(PC_OSI IMPORTED_TARGET osi)

  add_library(Coin::Osi ALIAS PkgConfig::PC_OSI)
endif()

find_path(OSI_INCLUDE_DIRS
          NAMES OsiConfig.h
          HINTS ${PC_OSI_INCLUDE_DIRS})

if (EXISTS "${OSI_INCLUDE_DIRS}/OsiConfig.h")
  file(STRINGS "${OSI_INCLUDE_DIRS}/OsiConfig.h" osi_version_str REGEX "^#define[\t ]+OSI_VERSION[\t ]+\".*\"")
  string(REGEX REPLACE "^#define[\t ]+OSI_VERSION[\t ]+\"([^\"]*)\".*" "\\1" Osi_VERSION "${osi_version_str}")
endif()


include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Osi
  REQUIRED_VARS OSI_INCLUDE_DIRS
  VERSION_VAR Osi_VERSION
	)
