add_library(dispatch SHARED IMPORTED)
set_property(TARGET dispatch PROPERTY IMPORTED_LOCATION "@out@/lib/libdispatch@dylibExt@")

add_library(swiftDispatch SHARED IMPORTED)
set_property(TARGET swiftDispatch PROPERTY IMPORTED_LOCATION "@out@/lib/libswiftDispatch@dylibExt@")
