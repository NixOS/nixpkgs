project(ImguiDemo LANGUAGES CXX)
cmake_minimum_required(VERSION 3.20)

add_executable(demo ./demo.cc)

find_package(imgui REQUIRED)
find_package(glfw3 REQUIRED)
find_package(OpenGL REQUIRED)
target_link_libraries(demo PRIVATE imgui glfw OpenGL::GL)

install(TARGETS demo RUNTIME DESTINATION bin)
