set(CollectionModules
    _RopeModule
    BasicContainers
    BitCollections
    Collections
    ContainersPreview
    DequeModule
    HashTreeCollections
    HeapModule
    InternalCollectionsUtilities
    OrderedCollections
    TrailingElementsModule
)

foreach(CollectionModule ${CollectionModules})
    add_library(SwiftCollections::${CollectionModule} @buildType@ IMPORTED)
    set_target_properties(SwiftCollections::${CollectionModule} PROPERTIES
        IMPORTED_LOCATION "@lib@/lib/${CMAKE_@buildType@_LIBRARY_PREFIX}${CollectionModule}${CMAKE_@buildType@_LIBRARY_SUFFIX}"
        INTERFACE_INCLUDE_DIRECTORIES "@include@/lib/swift/@swiftPlatform@"
    )
endforeach()
