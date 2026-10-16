set(SyntaxModules
    SwiftBasicFormat
    SwiftCompilerPlugin
    SwiftCompilerPluginMessageHandling
    SwiftDiagnostics
    SwiftIDEUtils
    SwiftIfConfig
    SwiftLexicalLookup
    SwiftOperators
    SwiftParser
    SwiftParserDiagnostics
    SwiftSyntax
    SwiftSyntaxBuilder
    SwiftSyntaxMacroExpansion
    SwiftSyntaxMacros
)

foreach(SyntaxModule ${SyntaxModules})
    add_library(SwiftSyntax::${SyntaxModule} @buildType@ IMPORTED)
    set_target_properties(SwiftSyntax::${SyntaxModule} PROPERTIES
        IMPORTED_LOCATION "@lib@/lib/swift/host/${CMAKE_@buildType@_LIBRARY_PREFIX}${SyntaxModule}${CMAKE_@buildType@_LIBRARY_SUFFIX}"
        INTERFACE_INCLUDE_DIRECTORIES "@dev@/lib/swift/host"
    )
endforeach()
