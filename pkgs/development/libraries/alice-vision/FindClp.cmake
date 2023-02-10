find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
  pkg_check_modules(PC_CLP IMPORTED_TARGET clp)

  add_library(Coin::Clp ALIAS PkgConfig::PC_CLP)
endif()

find_path(CLP_INCLUDE_DIRS
          NAMES ClpConfig.h
          HINTS ${PC_CLP_INCLUDE_DIRS})

if (EXISTS "${CLP_INCLUDE_DIRS}/ClpConfig.h")
  file(STRINGS "${CLP_INCLUDE_DIRS}/ClpConfig.h" clp_version_str REGEX "^#define[\t ]+CLP_VERSION[\t ]+\".*\"")
  string(REGEX REPLACE "^#define[\t ]+CLP_VERSION[\t ]+\"([^\"]*)\".*" "\\1" Clp_VERSION "${clp_version_str}")
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Clp
  REQUIRED_VARS CLP_INCLUDE_DIRS
  VERSION_VAR Clp_VERSION
	)
