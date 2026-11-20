set(ProtocolsModules
        _SKLoggingForPlugin
        _ToolsProtocolsSwiftExtensionsForPlugin
        BuildServerProtocol
        LanguageServerProtocol
        LanguageServerProtocolTransport
        SKLogging
        ToolsProtocolsSwiftExtensions
)

foreach(ProtocolsModule ${ProtocolsModules})
    add_library(SwiftToolsProtocols::${ProtocolsModule} @buildType@ IMPORTED)
    set_target_properties(SwiftToolsProtocols::${ProtocolsModule} PROPERTIES
            IMPORTED_LOCATION "@lib@/lib/${CMAKE_@buildType@_LIBRARY_PREFIX}${ProtocolsModule}${CMAKE_@buildType@_LIBRARY_SUFFIX}"
            INTERFACE_INCLUDE_DIRECTORIES "@dev@/include;@dev@/lib/swift/@swiftPlatform@"
    )
endforeach()
