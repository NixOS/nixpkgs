# tracy CPM uses NAME `tidy` and links against `tidy-static`.
# tracy also uses ${tidy_SOURCE_DIR}/include for headers.
# nixpkgs `html-tidy` provides `tidy` via pkg-config.
include(FindPkgConfig)
pkg_check_modules(TIDY REQUIRED IMPORTED_TARGET tidy)

add_library(tidy-static ALIAS PkgConfig::TIDY)

# TIDY_INCLUDE_DIRS is e.g. /nix/store/.../include, we need the parent
list(GET TIDY_INCLUDE_DIRS 0 _tidy_inc)
get_filename_component(tidy_SOURCE_DIR "${_tidy_inc}" DIRECTORY)

set(tidy_FOUND TRUE)
