add_library(X509 @buildType@ IMPORTED)
set_target_properties(X509 PROPERTIES
    IMPORTED_LOCATION "@lib@/lib/${CMAKE_@buildType@_LIBRARY_PREFIX}X509${CMAKE_@buildType@_LIBRARY_SUFFIX}"
    INTERFACE_INCLUDE_DIRECTORIES "@include@/lib/swift/@swiftPlatform@"
)
