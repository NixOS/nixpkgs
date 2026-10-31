add_library(_FoundationICU @buildType@ IMPORTED)
set_target_properties(_FoundationICU PROPERTIES
        IMPORTED_LOCATION "@lib@/lib/${CMAKE_@buildType@_LIBRARY_PREFIX}icucore${CMAKE_@buildType@_LIBRARY_SUFFIX}"
        INTERFACE_INCLUDE_DIRECTORIES "@dev@/lib/swift"
)
