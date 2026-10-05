add_library(Crypto @buildType@ IMPORTED)
set_target_properties(Crypto PROPERTIES
    IMPORTED_LOCATION "@lib@/lib/${CMAKE_@buildType@_LIBRARY_PREFIX}Crypto${CMAKE_@buildType@_LIBRARY_SUFFIX}"
    INTERFACE_INCLUDE_DIRECTORIES "@include@/lib/swift/@swiftPlatform@;@include@/lib/swift_static/@swiftPlatform@"
)
