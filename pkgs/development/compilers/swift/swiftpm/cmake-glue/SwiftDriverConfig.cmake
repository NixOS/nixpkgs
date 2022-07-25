add_library(SwiftDriver SHARED IMPORTED)
set_property(TARGET SwiftDriver PROPERTY IMPORTED_LOCATION "@out@/lib/libSwiftDriver@dylibExt@")

add_library(SwiftDriverExecution SHARED IMPORTED)
set_property(TARGET SwiftDriverExecution PROPERTY IMPORTED_LOCATION "@out@/lib/libSwiftDriverExecution@dylibExt@")

add_library(SwiftOptions SHARED IMPORTED)
set_property(TARGET SwiftOptions PROPERTY IMPORTED_LOCATION "@out@/lib/libSwiftOptions@dylibExt@")
