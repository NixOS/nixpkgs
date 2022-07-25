add_library(ArgumentParser SHARED IMPORTED)
set_property(TARGET ArgumentParser PROPERTY IMPORTED_LOCATION "@out@/lib/swift/@swiftOs@/libArgumentParser@dylibExt@")

add_library(ArgumentParserToolInfo SHARED IMPORTED)
set_property(TARGET ArgumentParserToolInfo PROPERTY IMPORTED_LOCATION "@out@/lib/swift/@swiftOs@/libArgumentParserToolInfo@dylibExt@")
