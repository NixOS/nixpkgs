if (NOT TARGET IndexStoreDB)
    add_library(IndexStoreDB @buildType@ IMPORTED)
    set_target_properties(IndexStoreDB PROPERTIES
            IMPORTED_LOCATION "@lib@/lib/${CMAKE_@buildType@_LIBRARY_PREFIX}IndexStoreDB${CMAKE_@buildType@_LIBRARY_SUFFIX}"
            INTERFACE_INCLUDE_DIRECTORIES "@dev@/lib/swift/@swiftPlatform@"
    )
endif ()
