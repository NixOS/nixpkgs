set(SwiftBuildModules
        SwiftBuild
        SWBBuildService
)

foreach (SwiftBuildModule ${SwiftBuildModules})
    if (NOT TARGET SwiftBuild::${SwiftBuildModule})
        add_library(SwiftBuild::${SwiftBuildModule} @buildType@ IMPORTED)
        set_target_properties(SwiftBuild::${SwiftBuildModule} PROPERTIES
                IMPORTED_LOCATION "@lib@/lib/${CMAKE_@buildType@_LIBRARY_PREFIX}${SwiftBuildModule}${CMAKE_@buildType@_LIBRARY_SUFFIX}"
                INTERFACE_INCLUDE_DIRECTORIES "@include@/include;@include@/lib/swift/@swiftPlatform@"
        )
    endif ()
endforeach ()
