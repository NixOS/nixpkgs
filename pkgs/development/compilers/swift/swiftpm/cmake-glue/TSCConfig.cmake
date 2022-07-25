add_library(TSCLibc SHARED IMPORTED)
set_property(TARGET TSCLibc PROPERTY IMPORTED_LOCATION "@out@/lib/libTSCLibc@dylibExt@")

add_library(TSCBasic SHARED IMPORTED)
set_property(TARGET TSCBasic PROPERTY IMPORTED_LOCATION "@out@/lib/libTSCBasic@dylibExt@")

add_library(TSCUtility SHARED IMPORTED)
set_property(TARGET TSCUtility PROPERTY IMPORTED_LOCATION "@out@/lib/libTSCUtility@dylibExt@")
