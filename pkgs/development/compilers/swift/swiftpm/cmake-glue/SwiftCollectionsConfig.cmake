add_library(SwiftCollections::Collections STATIC IMPORTED)
set_property(TARGET SwiftCollections::Collections PROPERTY IMPORTED_LOCATION "@out@/lib/swift_static/@swiftOs@/libCollections@staticLibExt@")

add_library(SwiftCollections::DequeModule STATIC IMPORTED)
set_property(TARGET SwiftCollections::DequeModule PROPERTY IMPORTED_LOCATION "@out@/lib/swift_static/@swiftOs@/libDequeModule@staticLibExt@")

add_library(SwiftCollections::OrderedCollections STATIC IMPORTED)
set_property(TARGET SwiftCollections::OrderedCollections PROPERTY IMPORTED_LOCATION "@out@/lib/swift_static/@swiftOs@/libOrderedCollections@staticLibExt@")
