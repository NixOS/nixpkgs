cmake_minimum_required(VERSION 3.17)
project(mpich-tests LANGUAGES C)
find_package(MPI REQUIRED)

add_executable(cpi ./cpi.c)
add_executable(cpi-asan ./cpi.c)

target_link_libraries(cpi PRIVATE MPI::MPI_C)
target_link_libraries(cpi-asan PRIVATE MPI::MPI_C -fsanitize=address)
install(TARGETS cpi cpi-asan)
