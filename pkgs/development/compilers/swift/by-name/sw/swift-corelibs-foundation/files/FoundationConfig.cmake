find_package(_FoundationICU)
find_package(SwiftCollections)
find_package(SwiftFoundation)

if (NOT TARGET Foundation)
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
endif ()
