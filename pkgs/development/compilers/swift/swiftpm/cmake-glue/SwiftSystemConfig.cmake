add_library(SwiftSystem::SystemPackage STATIC IMPORTED)
set_property(TARGET SwiftSystem::SystemPackage PROPERTY IMPORTED_LOCATION "@out@/lib/swift_static/@swiftOs@/libSystemPackage@staticLibExt@")
