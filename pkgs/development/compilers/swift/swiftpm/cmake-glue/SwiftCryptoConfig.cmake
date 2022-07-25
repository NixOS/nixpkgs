add_library(Crypto SHARED IMPORTED)
set_property(TARGET Crypto PROPERTY IMPORTED_LOCATION "@out@/lib/swift/@swiftOs@/libCrypto@dylibExt@")
