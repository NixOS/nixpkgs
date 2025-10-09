add_library(Foundation SHARED IMPORTED)
set_property(TARGET Foundation PROPERTY IMPORTED_LOCATION "@out@/lib/swift/@swiftOs@/libFoundation@dylibExt@")

add_library(FoundationNetworking SHARED IMPORTED)
set_property(TARGET FoundationNetworking PROPERTY IMPORTED_LOCATION "@out@/lib/swift/@swiftOs@/libFoundationNetworking@dylibExt@")

add_library(FoundationXML SHARED IMPORTED)
set_property(TARGET FoundationXML PROPERTY IMPORTED_LOCATION "@out@/lib/swift/@swiftOs@/libFoundationXML@dylibExt@")
