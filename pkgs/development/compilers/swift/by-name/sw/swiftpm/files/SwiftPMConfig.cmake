set(SwiftPMModules
        _AsyncFileSystem
        Basics
        Build
        Commands
        CoreCommands
        DriverSupport
        PackageCollections
        PackageCollectionsCommand
        PackageCollectionsModel
        PackageCollectionsSigning
        PackageGraph
        PackageLoading
        PackageModel
        PackageRegistryCommand
        QueryEngine
        SPMBuildCore
        SourceControl
        SwiftBuildSupport
        SwiftSDKCommand
        Workspace
)

foreach (SwiftPMModule ${SwiftPMModules})
    if (NOT TARGET ${SwiftPMModule})
        add_library(${SwiftPMModule} @buildType@ IMPORTED)
        set_target_properties(${SwiftPMModule} PROPERTIES
                IMPORTED_LOCATION "@lib@/lib/${CMAKE_@buildType@_LIBRARY_PREFIX}${SwiftPMModule}${CMAKE_@buildType@_LIBRARY_SUFFIX}"
                INTERFACE_INCLUDE_DIRECTORIES "@dev@/lib/swift/@swiftPlatform@"
        )
    endif ()
endforeach ()


set(SwiftPMManifestModules
        CompilerPluginSupport
        PackageDescription
)

foreach (SwiftPMModule ${SwiftPMManifestModules})
    if (NOT TARGET ${SwiftPMModule})
        add_library(${SwiftPMModule} @buildType@ IMPORTED)
        set_target_properties(${SwiftPMModule} PROPERTIES
                IMPORTED_LOCATION "@lib@/lib/swift/pm/ManifestAPI/${CMAKE_@buildType@_LIBRARY_PREFIX}${SwiftPMModule}${CMAKE_@buildType@_LIBRARY_SUFFIX}"
                INTERFACE_INCLUDE_DIRECTORIES "@lib@/lib/swift/pm/ManifestAPI"
        )
    endif ()
endforeach ()

set(SwiftPMPluginModules
        PackagePlugin
)


foreach (SwiftPMModule ${SwiftPMPluginModules})
    if (NOT TARGET ${SwiftPMModule})
        add_library(${SwiftPMModule} @buildType@ IMPORTED)
        set_target_properties(${SwiftPMModule} PROPERTIES
                IMPORTED_LOCATION "@lib@/lib/swift/pm/PluginAPI/${CMAKE_@buildType@_LIBRARY_PREFIX}${SwiftPMModule}${CMAKE_@buildType@_LIBRARY_SUFFIX}"
                INTERFACE_INCLUDE_DIRECTORIES "@lib@/lib/swift/pm/PluginAPI"
        )
    endif ()
endforeach ()


set(SwiftPMStaticModules
        LLBuildManifest
        PackageFingerprint
        PackageRegistry
        PackageSigning
        SourceKitLSPAPI
        SPMLLBuild
)

foreach (SwiftPMModule ${SwiftPMStaticModules})
    if (NOT TARGET ${SwiftPMModule})
        add_library(${SwiftPMModule} STATIC IMPORTED)
        set_target_properties(${SwiftPMModule} PROPERTIES
                IMPORTED_LOCATION "@dev@/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${SwiftPMModule}${CMAKE_STATIC_LIBRARY_SUFFIX}"
                INTERFACE_INCLUDE_DIRECTORIES "@dev@/lib/swift_static/@swiftPlatform@"
        )
    endif ()
endforeach ()
