if (NOT TARGET _FoundationICU)
    find_package(_FoundationICU)
endif ()

if (NOT TARGET SwiftCollections::_RopeModule)
    find_package(SwiftCollections)
endif ()

if (NOT TARGET FoundationEssentials)
    find_package(SwiftFoundation)
endif ()

add_library(Foundation @buildType@ IMPORTED)
set_target_properties(Foundation PROPERTIES
        IMPORTED_LOCATION "@lib@/lib/${CMAKE_@buildType@_LIBRARY_PREFIX}Foundation${CMAKE_@buildType@_LIBRARY_SUFFIX}"
        INTERFACE_INCLUDE_DIRECTORIES "@dev@/lib/swift;@dev@/lib/swift/@swiftPlatform@"
)
target_link_libraries(FoundationEssentials INTERFACE
        _FoundationICU
        FoundationEssentials
        FoundationInternationalization
        SwiftCollections::_RopeModule
        SwiftCollections::InternalCollectionsUtilities
        SwiftCollections::OrderedCollections
)
