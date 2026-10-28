if (NOT TARGET SwiftCollections::_RopeModule)
    find_package(SwiftCollections)
endif()

add_library(FoundationEssentials @buildType@ IMPORTED)
set_target_properties(FoundationEssentials PROPERTIES
        IMPORTED_LOCATION "@lib@/lib/${CMAKE_@buildType@_LIBRARY_PREFIX}FoundationEssentials${CMAKE_@buildType@_LIBRARY_SUFFIX}"
        INTERFACE_INCLUDE_DIRECTORIES "@dev@/lib/swift;@dev@/lib/swift/@swiftPlatform@"
)

if (NOT TARGET _FoundationICU)
    find_package(_FoundationICU)
endif()

add_library(FoundationInternationalization @buildType@ IMPORTED)
set_target_properties(FoundationInternationalization PROPERTIES
        IMPORTED_LOCATION "@lib@/lib/${CMAKE_@buildType@_LIBRARY_PREFIX}FoundationInternationalization${CMAKE_@buildType@_LIBRARY_SUFFIX}"
        INTERFACE_INCLUDE_DIRECTORIES "@dev@/lib/swift/@swiftPlatform@"
)

target_link_libraries(FoundationEssentials INTERFACE
        _FoundationICU
)
