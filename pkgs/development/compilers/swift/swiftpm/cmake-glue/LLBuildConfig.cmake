add_library(libllbuild SHARED IMPORTED)
set_property(TARGET libllbuild PROPERTY IMPORTED_LOCATION "@out@/lib/libllbuild@dylibExt@")

add_library(llbuildSwift SHARED IMPORTED)
set_property(TARGET llbuildSwift PROPERTY IMPORTED_LOCATION "@out@/lib/swift/pm/llbuild/libllbuildSwift@dylibExt@")
