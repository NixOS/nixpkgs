add_library(SwiftASN1 @buildType@ IMPORTED)
set_target_properties(SwiftASN1 PROPERTIES
    IMPORTED_LOCATION "@lib@/lib/${CMAKE_@buildType@_LIBRARY_PREFIX}SwiftASN1${CMAKE_@buildType@_LIBRARY_SUFFIX}"
    INTERFACE_INCLUDE_DIRECTORIES "@include@/lib/swift/@swiftPlatform@"
)
