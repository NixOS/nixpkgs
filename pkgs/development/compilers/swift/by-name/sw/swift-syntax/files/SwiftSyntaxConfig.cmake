set(SyntaxModules
    @syntaxModules@
)

foreach(SyntaxModule ${SyntaxModules})
    add_library(SwiftSyntax::${SyntaxModule} @buildType@ IMPORTED)
    set_target_properties(SwiftSyntax::${SyntaxModule} PROPERTIES
        IMPORTED_LOCATION "@lib@/lib/swift/host/${CMAKE_@buildType@_LIBRARY_PREFIX}${SyntaxModule}${CMAKE_@buildType@_LIBRARY_SUFFIX}"
        INTERFACE_INCLUDE_DIRECTORIES "@dev@/lib/swift/host"
    )
endforeach()
