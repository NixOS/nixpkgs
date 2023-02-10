find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
  pkg_check_modules(PC_COINUTILS IMPORTED_TARGET coinutils)

  add_library(Coin::CoinUtils ALIAS PkgConfig::PC_COINUTILS)
endif()

find_path(COINUTILS_INCLUDE_DIRS
          NAMES CoinUtilsConfig.h
          HINTS ${PC_COINUTILS_INCLUDE_DIRS})

if (EXISTS "${COINUTILS_INCLUDE_DIRS}/CoinUtilsConfig.h")
  file(STRINGS "${COINUTILS_INCLUDE_DIRS}/CoinUtilsConfig.h" coinutils_version_str REGEX "^#define[\t ]+COINUTILS_VERSION[\t ]+\".*\"")
  string(REGEX REPLACE "^#define[\t ]+COINUTILS_VERSION[\t ]+\"([^\"]*)\".*" "\\1" CoinUtils_VERSION "${coinutils_version_str}")
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(CoinUtils
  REQUIRED_VARS COINUTILS_INCLUDE_DIRS
  VERSION_VAR CoinUtils_VERSION
	)
