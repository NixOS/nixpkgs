{
  addDriverRunpath,
  backendCC,
  backendStdenv,
  cmake,
  cuda_nvcc,
  cudaNamePrefix,
  flags,
  lib,
  libnvshmem,
  ninja,
}:
let
  cc = backendCC.__spliced.buildHost or backendCC;
  expectedVersion = lib.replaceStrings [ "-" ] [ "." ] libnvshmem.version;
in
backendStdenv.mkDerivation {
  name = "${cudaNamePrefix}-tests-nvshmem-cmake";
  strictDeps = true;
  nativeBuildInputs = [
    addDriverRunpath
    cmake
    cuda_nvcc
    ninja
  ];
  # CCCL and CUDA development metadata must arrive through NVSHMEM's interface.
  buildInputs = [ libnvshmem ];
  buildCommand = ''
    cat > CMakeLists.txt <<'CMAKE'
    cmake_minimum_required(VERSION 3.25)
    project(nvshmem_consumer LANGUAGES CXX)
    if(REJECT_VERSION)
      find_package(NVSHMEM 999 CONFIG QUIET)
      if(NVSHMEM_FOUND)
        message(FATAL_ERROR "NVSHMEM accepted an unsatisfiable version")
      endif()
      return()
    endif()
    # Discover the dependency before enabling CUDA: a host API consumer need
    # not compile a CUDA translation unit to obtain the toolkit interface.
    find_package(NVSHMEM ${lib.versions.majorMinor libnvshmem.version} CONFIG REQUIRED)
    if(NOT NVSHMEM_VERSION VERSION_EQUAL "${expectedVersion}")
      message(FATAL_ERROR "Incorrect NVSHMEM_VERSION: ''${NVSHMEM_VERSION}")
    endif()
    foreach(target IN ITEMS nvshmem_host nvshmem_device)
      get_target_property(dependencies nvshmem::''${target} INTERFACE_LINK_LIBRARIES)
      if(NOT "CUDA::toolkit" IN_LIST dependencies)
        message(FATAL_ERROR "''${target} omits its public CUDA header interface")
      endif()
    endforeach()
    add_executable(host host.cpp)
    target_link_libraries(host PRIVATE nvshmem::nvshmem_host)
    enable_language(CUDA)
    add_executable(device device.cu)
    set_target_properties(device PROPERTIES CUDA_SEPARABLE_COMPILATION ON)
    target_link_libraries(device PRIVATE nvshmem::nvshmem_device nvshmem::nvshmem_host)
    CMAKE
    cat > host.cpp <<'CPP'
    #include <nvshmem_host.h>
    int main() {
      char name[256]{};
      nvshmem_info_get_name(name);
      return name[0] == '\0';
    }
    CPP
    # Execute this GPU regression outside the sandbox on the HOST machine.
    cp ${./nvshmem-device.cu} device.cu

    # Keep role-aware CMake discovery, but do not let compiler input flags
    # conceal missing include or library properties on imported targets.
    for role in "" _FOR_BUILD _FOR_HOST _FOR_TARGET; do
      unset "NIX_CFLAGS_COMPILE$role" "NIX_LDFLAGS$role"
    done
    unset CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH LIBRARY_PATH
    args=(
      -S . -G Ninja
      -DCMAKE_CXX_COMPILER="$CXX"
      -DCMAKE_CUDA_COMPILER="$CUDACXX"
      -DCMAKE_CUDA_ARCHITECTURES=${lib.escapeShellArg flags.cmakeCudaArchitecturesString}
      -DCMAKE_LIBRARY_PATH=${lib.getLib cc.libc}/lib
      -DNVSHMEM_DIR=${libnvshmem}/lib/cmake/nvshmem
      ${lib.optionalString (backendStdenv.buildPlatform != backendStdenv.hostPlatform) ''
        -DCMAKE_SYSTEM_NAME=Linux
        -DCMAKE_SYSTEM_PROCESSOR=${backendStdenv.hostPlatform.parsed.cpu.name}
      ''}
    )
    cmake "''${args[@]}" -B build
    cmake --build build --verbose
    cmake "''${args[@]}" -B reject -DREJECT_VERSION=ON
    mkdir -p "$out/bin" "$out/share"
    cp build/{host,device} "$out/bin/"
    # buildCommand does not run fixupPhase. The executable's static CUDA
    # runtime dlopens the machine's driver, as in other CUDA sample programs.
    addDriverRunpath "$out/bin/device"
    cp build/CMakeCache.txt "$out/share/"
    ${lib.optionalString (backendStdenv.buildPlatform.canExecute backendStdenv.hostPlatform) ''
      "$out/bin/host"
    ''}
  '';
}
