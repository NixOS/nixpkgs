add_library(llbuild STATIC IMPORTED)
set_target_properties(llbuild PROPERTIES
    IMPORTED_LOCATION "@lib@/lib/${CMAKE_STATIC_LIBRARY_PREFIX}llbuild${CMAKE_STATIC_LIBRARY_SUFFIX}"
    INTERFACE_INCLUDE_DIRECTORIES "@dev@/include"
)

add_library(llbuildSwift @buildType@ IMPORTED)
set_target_properties(llbuildSwift PROPERTIES
    IMPORTED_LOCATION "@lib@/lib/${CMAKE_@buildType@_LIBRARY_PREFIX}llbuildSwift${CMAKE_@buildType@_LIBRARY_SUFFIX}"
    INTERFACE_INCLUDE_DIRECTORIES "@dev@/include;@dev@/lib/swift/@swiftPlatform@"
)
