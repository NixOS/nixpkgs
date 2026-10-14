add_library(TSCBasic @buildType@ IMPORTED)
set_target_properties(TSCBasic PROPERTIES
    IMPORTED_LOCATION "@lib@/lib/${CMAKE_@buildType@_LIBRARY_PREFIX}SwiftToolsSupport${CMAKE_@buildType@_LIBRARY_SUFFIX}"
    INTERFACE_INCLUDE_DIRECTORIES "@dev@/include;@dev@/lib/swift/@swiftPlatform@"
)

add_library(TSCUtility @buildType@ IMPORTED)
set_target_properties(TSCUtility PROPERTIES
    IMPORTED_LOCATION "@lib@/lib/${CMAKE_@buildType@_LIBRARY_PREFIX}SwiftToolsSupport${CMAKE_@buildType@_LIBRARY_SUFFIX}"
    INTERFACE_INCLUDE_DIRECTORIES "@dev@/include;@dev@/lib/swift/@swiftPlatform@"
)
