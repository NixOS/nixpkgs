find_package(SwiftCollections)

if(NOT TARGET FoundationEssentials)
    add_library(FoundationEssentials @buildType@ IMPORTED)
    set_target_properties(FoundationEssentials PROPERTIES
            IMPORTED_LOCATION "@dev@/lib/swift/@swiftPlatform@/${CMAKE_@buildType@_LIBRARY_PREFIX}FoundationEssentials${CMAKE_@buildType@_LIBRARY_SUFFIX}"
            INTERFACE_INCLUDE_DIRECTORIES "@dev@/lib/swift;@dev@/lib/swift/@swiftPlatform@"
    )
endif()

find_package(_FoundationICU)

if(NOT TARGET FoundationInternationalization)
    add_library(FoundationInternationalization @buildType@ IMPORTED)
    set_target_properties(FoundationInternationalization PROPERTIES
            IMPORTED_LOCATION "@dev@/lib/swift/@swiftPlatform@/${CMAKE_@buildType@_LIBRARY_PREFIX}FoundationInternationalization${CMAKE_@buildType@_LIBRARY_SUFFIX}"
            INTERFACE_INCLUDE_DIRECTORIES "@dev@/lib/swift/@swiftPlatform@"
    )
    target_link_libraries(FoundationEssentials INTERFACE
            _FoundationICU
    )
endif()
