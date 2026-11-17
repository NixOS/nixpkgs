add_library(SwiftDriver @buildType@ IMPORTED)
set_target_properties(SwiftDriver PROPERTIES
    IMPORTED_LOCATION "@lib@/lib/${CMAKE_@buildType@_LIBRARY_PREFIX}SwiftDriver${CMAKE_@buildType@_LIBRARY_SUFFIX}"
    INTERFACE_INCLUDE_DIRECTORIES "@dev@/lib/swift/@swiftPlatform@"
)
