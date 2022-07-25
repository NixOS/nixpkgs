add_library(CYaml SHARED IMPORTED)
set_property(TARGET CYaml PROPERTY IMPORTED_LOCATION "@out@/lib/libCYaml@dylibExt@")

add_library(Yams SHARED IMPORTED)
set_property(TARGET Yams PROPERTY IMPORTED_LOCATION "@out@/lib/swift/@swiftOs@/libYams@dylibExt@")
