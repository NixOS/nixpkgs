add_library(BlocksRuntime @buildType@ IMPORTED)
set_target_properties(BlocksRuntime PROPERTIES
    IMPORTED_LOCATION "@lib@/lib/${CMAKE_@buildType@_LIBRARY_PREFIX}BlocksRuntime${CMAKE_@buildType@_LIBRARY_SUFFIX}"
)

add_library(dispatch @buildType@ IMPORTED)
set_target_properties(dispatch PROPERTIES
    IMPORTED_LOCATION "@lib@/lib/${CMAKE_@buildType@_LIBRARY_PREFIX}dispatch${CMAKE_@buildType@_LIBRARY_SUFFIX}"
)

set_target_properties(dispatch PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "@dev@/include"
    INTERFACE_LINK_LIBRARIES "BlocksRuntime"
)

add_library(swiftDispatch @buildType@ IMPORTED)
set_target_properties(swiftDispatch PROPERTIES
    IMPORTED_LOCATION "@out-swift@/lib/${CMAKE_@buildType@_LIBRARY_PREFIX}swiftDispatch${CMAKE_@buildType@_LIBRARY_SUFFIX}"
    INTERFACE_INCLUDE_DIRECTORIES "@dev-swift@/lib/swift;@dev-swift@/lib/swift/@swiftPlatform@"
)
