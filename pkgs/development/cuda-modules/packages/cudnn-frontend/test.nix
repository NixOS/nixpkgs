{
  cmake,
  cuda_nvcc,
  lib,
  package,
  stdenv,
  withJson,
}:
stdenv.mkDerivation {
  name = "${package.name}-cmake-consumer";
  strictDeps = true;
  dontUnpack = true;
  nativeBuildInputs = [
    cmake
    cuda_nvcc
  ];
  buildInputs = [ package ];
  preConfigure = ''
    cat > main.cpp <<'CPP'
    #include <cudnn_frontend.h>
    #if defined(CUDNN_FRONTEND_SKIP_JSON_LIB) != ${if withJson then "0" else "1"}
    #error The exported JSON option does not match the installed interface
    #endif
    int main() {
      #ifndef CUDNN_FRONTEND_SKIP_JSON_LIB
      if (nlohmann::json(1).get<int>() != 1) return 1;
      #endif
      int major = 0, minor = 0;
      return cudnnGetVersion() == 0 || nvrtcVersion(&major, &minor) != NVRTC_SUCCESS;
    }
    CPP
    # Ordinary stdenv users must receive the public headers through propagation.
    $CXX -std=c++17 ${
      lib.optionalString (!withJson) "-DCUDNN_FRONTEND_SKIP_JSON_LIB"
    } -fsyntax-only main.cpp
    # CMake must supply its own usage requirements; dependency flags cannot
    # conceal an incomplete imported interface.
    for variable in ''${!NIX_CFLAGS_COMPILE@} ''${!NIX_LDFLAGS@}; do
      unset "$variable"
    done
    unset CPATH CPLUS_INCLUDE_PATH LIBRARY_PATH
    cat > CMakeLists.txt <<'CMAKE'
    cmake_minimum_required(VERSION 3.25)
    project(frontend_consumer LANGUAGES CXX)
    find_package(cudnn_frontend CONFIG REQUIRED)
    # The wrapper flags were cleared above. Let CMake retain the imported
    # libraries' directories when installing this standalone consumer.
    set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
    add_executable(consumer main.cpp)
    target_link_libraries(consumer PRIVATE cudnn_frontend)
    install(TARGETS consumer DESTINATION bin)
    CMAKE
  '';
  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  installCheckPhase = ''
    runHook preInstallCheck
    "$out/bin/consumer"
    runHook postInstallCheck
  '';
}
