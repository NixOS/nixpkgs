add_library(ArgumentParser @buildType@ IMPORTED)
set_target_properties(ArgumentParser PROPERTIES
    IMPORTED_LOCATION "@lib@/lib/${CMAKE_@buildType@_LIBRARY_PREFIX}ArgumentParser${CMAKE_@buildType@_LIBRARY_SUFFIX}"
    INTERFACE_INCLUDE_DIRECTORIES "@include@/lib/swift/@swiftPlatform@;@include@/lib/swift_static/@swiftPlatform@"
)
