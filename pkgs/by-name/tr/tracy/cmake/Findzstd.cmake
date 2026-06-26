# nixpkgs `zstd` provides `zstd::libzstd` but tracy links against `libzstd`.
#
# Using CONFIG mode bypasses FindPackage modules, so this won't recurse.
find_package(zstd CONFIG REQUIRED)

add_library(libzstd INTERFACE IMPORTED GLOBAL)
target_link_libraries(libzstd INTERFACE zstd::libzstd)
