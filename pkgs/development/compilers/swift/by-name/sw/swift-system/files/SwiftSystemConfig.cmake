add_library(CSystem STATIC IMPORTED)
set_target_properties(CSystem PROPERTIES
    IMPORTED_LOCATION "@lib@/lib/${CMAKE_STATIC_LIBRARY_PREFIX}CSystem${CMAKE_STATIC_LIBRARY_SUFFIX}"
)

add_library(SwiftSystem::SystemPackage STATIC IMPORTED)
set_target_properties(SwiftSystem::SystemPackage PROPERTIES
    IMPORTED_LOCATION "@lib@/lib/${CMAKE_STATIC_LIBRARY_PREFIX}SystemPackage${CMAKE_STATIC_LIBRARY_SUFFIX}"
    INTERFACE_LINK_LIBRARIES CSystem
    INTERFACE_INCLUDE_DIRECTORIES "@dev@/include;@dev@/lib/swift_static/@swiftPlatform@"
)
