set(ulog_cpp_LIBRARIES "${CMAKE_CURRENT_LIST_DIR}/../../lib/libulog_cpp.a")
set(ulog_cpp_INCLUDE_DIRS "${CMAKE_CURRENT_LIST_DIR}/../../include")

add_library(ulog_cpp::ulog_cpp STATIC IMPORTED ALIAS ulog_cpp)
set_target_properties(ulog_cpp::ulog_cpp PROPERTIES
    IMPORTED_LOCATION "${ulog_cpp_LIBRARY}"
    INTERFACE_INCLUDE_DIRECTORIES "${ulog_cpp_INCLUDE_DIR}"
)
