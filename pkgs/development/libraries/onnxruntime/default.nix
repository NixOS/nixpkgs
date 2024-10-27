{ config
, applyPatches
, stdenv
, lib
, fetchFromGitHub
, Foundation
, howard-hinnant-date
, cmake
, cpuinfo
, eigen
, flatbuffers_23
, gbenchmark
, glibcLocales
, gtest
, libpng
, nlohmann_json
, nsync
, pkg-config
, python3Packages
, re2
, zlib
, microsoft-gsl
, libiconv
, protobuf
, pythonSupport ? true
, cudaSupport ? config.cudaSupport
, ncclSupport ? config.cudaSupport
, cudaPackages ? {}
}@inputs:


let
  version = "1.19.2";

  stdenv = throw "Use effectiveStdenv instead";
  effectiveStdenv = if cudaSupport then cudaPackages.backendStdenv else inputs.stdenv;

  cudaArchitecturesString = cudaPackages.flags.cmakeCudaArchitecturesString;

  mp11 = fetchFromGitHub {
    owner = "boostorg";
    repo = "mp11";
    rev = "boost-1.82.0";
    hash = "sha256-cLPvjkf2Au+B19PJNrUkTW/VPxybi1MpPxnIl4oo4/o=";
  };

  safeint = fetchFromGitHub {
    owner = "dcleblanc";
    repo = "safeint";
    rev = "ff15c6ada150a5018c5ef2172401cb4529eac9c0";
    hash = "sha256-PK1ce4C0uCR4TzLFg+elZdSk5DdPCRhhwT3LvEwWnPU=";
  };

  pytorch_clog = effectiveStdenv.mkDerivation {
    pname = "clog";
    version = "3c8b153";
    src = "${cpuinfo.src}/deps/clog";

    nativeBuildInputs = [ cmake gbenchmark gtest ];
    cmakeFlags = [
      "-DUSE_SYSTEM_GOOGLEBENCHMARK=ON"
      "-DUSE_SYSTEM_GOOGLETEST=ON"
      "-DUSE_SYSTEM_LIBS=ON"
      # 'clog' tests set 'CXX_STANDARD 11'; this conflicts with our 'gtest'.
      "-DCLOG_BUILD_TESTS=OFF"
    ];
  };
   cutlass = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cutlass";
    rev = "v3.1.0";
    hash = "sha256-mpaiCxiYR1WaSSkcEPTzvcREenJWklD+HRdTT5/pD54=";
 };
in
effectiveStdenv.mkDerivation rec {
  pname = "onnxruntime";
  inherit version;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "onnxruntime";
    rev = "refs/tags/v${version}";
    hash = "sha256-LLTPDvdWdK+2yo7uRVzjEQOEmc2ISEQ1Hp2SZSYSpSU=";
    fetchSubmodules = true;
  };

  patches =
    [ ]
    ++ lib.optionals cudaSupport [
      # We apply the referenced 1064.patch ourselves to our nix dependency.
      #  FIND_PACKAGE_ARGS for CUDA was added in https://github.com/microsoft/onnxruntime/commit/87744e5 so it might be possible to delete this patch after upgrading to 1.17.0
      ./nvcc-gsl.patch
    ];

  nativeBuildInputs = [
    cmake
    pkg-config
    python3Packages.python
    protobuf
  ] ++ lib.optionals pythonSupport (with python3Packages; [
    pip
    python
    pythonOutputDistHook
    setuptools
    wheel
  ]) ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
  ];

  buildInputs = [
    (with python3Packages; toPythonApplication onnx)
    re2
    gtest
    howard-hinnant-date
    nsync
    flatbuffers_23
    # NOTE: abseil-cpp already propagated by protobuf
    cpuinfo
    eigen
    glibcLocales
    libpng
    nlohmann_json
    microsoft-gsl
    pytorch_clog
    zlib
  ] ++ lib.optionals pythonSupport (with python3Packages; [
    numpy
    pybind11
    packaging
  ]) ++ lib.optionals effectiveStdenv.hostPlatform.isDarwin [
    Foundation
    libiconv
  ] ++ lib.optionals cudaSupport (with cudaPackages; [
    cuda_cccl # cub/cub.cuh
    libcublas # cublas_v2.h
    libcurand # curand.h
    libcusparse # cusparse.h
    libcufft # cufft.h
    cudnn # cudnn.h
    cuda_cudart
  ] ++ lib.optionals (cudaSupport && ncclSupport) (with cudaPackages; [
    nccl
  ]));

  nativeCheckInputs = [
    gtest
  ] ++ lib.optionals pythonSupport (with python3Packages; [
    pytest
    sympy
    onnx
  ]);

  # TODO: build server, and move .so's to lib output
  # Python's wheel is stored in a separate dist output
  outputs = [ "out" "dev" ] ++ lib.optionals pythonSupport [ "dist" ];

  enableParallelBuilding = true;

  cmakeDir = "../cmake";

  cmakeFlags = [
    # (lib.cmakeBool "CMAKE_FIND_DEBUG_MODE" true)
    "-DFETCHCONTENT_FULLY_DISCONNECTED=ON"
    "-DFETCHCONTENT_QUIET=OFF"
    # "-DFETCHCONTENT_SOURCE_DIR_DATE=${howard-hinnant-date}"
    "-DFETCHCONTENT_SOURCE_DIR_FLATBUFFERS=${flatbuffers_23.src}"
    "-DFETCHCONTENT_SOURCE_DIR_GOOGLETEST=${gtest.src}"
    "-DFETCHCONTENT_SOURCE_DIR_GOOGLE_NSYNC=${nsync.src}"
    "-DFETCHCONTENT_SOURCE_DIR_MP11=${mp11}"
    # "-DFETCHCONTENT_SOURCE_DIR_ONNX=${onnx}"
    # "-DFETCHCONTENT_SOURCE_DIR_RE2=${re2.src}"
    "-DFETCHCONTENT_SOURCE_DIR_SAFEINT=${safeint}"
    "-DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS"
    "-Donnxruntime_BUILD_SHARED_LIB=ON"
    (lib.cmakeBool "onnxruntime_BUILD_UNIT_TESTS" doCheck)
    "-Donnxruntime_ENABLE_LTO=ON"
    "-Donnxruntime_USE_FULL_PROTOBUF=OFF"
    (lib.cmakeBool "onnxruntime_USE_CUDA" cudaSupport)
    (lib.cmakeBool "onnxruntime_USE_NCCL" (cudaSupport && ncclSupport))
  ] ++ lib.optionals pythonSupport [
    "-Donnxruntime_ENABLE_PYTHON=ON"
  ] ++ lib.optionals cudaSupport [
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_CUTLASS" "${cutlass}")
    (lib.cmakeFeature "onnxruntime_CUDNN_HOME" "${cudaPackages.cudnn}")
    (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" cudaArchitecturesString)
    (lib.cmakeFeature "onnxruntime_NVCC_THREADS" "1")
  ];

  env = lib.optionalAttrs effectiveStdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=deprecated-declarations"
      "-Wno-error=deprecated-pragma"
      "-Wno-error=unused-but-set-variable"
    ];
  };

  # aarch64-linux fails cpuinfo test, because /sys/devices/system/cpu/ does not exist in the sandbox
  doCheck = !(cudaSupport || effectiveStdenv.buildPlatform.system == "aarch64-linux");

  requiredSystemFeatures = lib.optionals cudaSupport [ "big-parallel" ];

  cmakeBuildDir = "build"; # We reference the var during postPatch/before configurePhase
  dontExternalDeps = ''
    include(external/abseil-cpp.cmake)
    find_package(re2 REQUIRED)
    # TODO: Emscripten
    find_package(GTest REQUIRED)
    # TOOD: what is google_benchmark
    if (NOT WIN32)
      find_package(nsync REQUIRED)
    endif()
    if (onnxruntime_USE_MIMALLOC)
      find_package(mimalloc REQUIRED)
    endif()
    find_package(flatbuffers REQUIRED) # TODO: override with patches/flatbuffers/flatbuffers.patch
    find_package(utf8_range REQUIRED) # Comes with protobuf?
    find_package(protobuf REQUIRED) # protoc?
    include(protobuf_function)
    find_package(date REQUIRED)
    find_package(boost REQUIRED) # mp11
    find_package(nlohmann_json REQUIRED)
    set(CPUINFO_SUPPORTED FALSE) # FIXME: disabled so as not to deal with pytorch_clog
    find_package(Microsoft.GSL REQUIRED)
    include(eigen)
    include(wil)
    find_package(ONNX REQUIRED)

    set(safeint_SOURCE_DIR "${safeint}")
    add_library(safeint_interface INTERFACE)
    target_include_directories(safeint_interface INTERFACE ''${safeint_SOURCE_DIR})

    # TODO : XNNPACK

    if (onnxruntime_USE_MIMALLOC)
      add_definitions(-DUSE_MIMALLOC)
    endif()

    # Copy-pasted...
    set(onnxruntime_EXTERNAL_LIBRARIES ''${onnxruntime_EXTERNAL_LIBRARIES_XNNPACK} ''${WIL_TARGET} nlohmann_json::nlohmann_json onnx onnx_proto ''${PROTOBUF_LIB} re2::re2 Boost::mp11 safeint_interface flatbuffers::flatbuffers ''${GSL_TARGET} ''${ABSEIL_LIBS} date::date ''${ONNXRUNTIME_CLOG_TARGET_NAME})
    set(onnxruntime_EXTERNAL_DEPENDENCIES onnx_proto flatbuffers::flatbuffers)
    if (onnxruntime_RUN_ONNX_TESTS)
      add_definitions(-DORT_RUN_EXTERNAL_ONNX_TESTS)
    endif()

    # TODO: dlpack

    if(onnxruntime_ENABLE_TRAINING OR (onnxruntime_ENABLE_TRAINING_APIS AND onnxruntime_BUILD_UNIT_TESTS))
      find_package(cxxopts REQUIRED)
    endif()

    # TODO: CoreML/Apple stuff

    if (onnxruntime_USE_CUDA)
      find_package(CUDAToolkit REQUIRED)
    endif()

    # TODO: SNPE

    FILE(TO_NATIVE_PATH ''${CMAKE_BINARY_DIR}  ORT_BINARY_DIR)
    FILE(TO_NATIVE_PATH ''${PROJECT_SOURCE_DIR}  ORT_SOURCE_DIR)
  '';

  # Copy-pasted from cmake/external/onnxruntime_external_deps.cmake
  gdkCstdlibWrapper = ''
    #pragma once
#ifdef __cplusplus
#include <cstdlib>
namespace std { using ::getenv; }
#endif
  '';
  prePatch = ''
    mkdir "$cmakeBuildDir"
  '';
  postPatch = ''
    printf "%s" "$dontExternalDeps" > cmake/external/onnxruntime_external_deps.cmake
    printf "%s" "$gdkCstdlibWrapper" > "$cmakeBuildDir/gdk_cstdlib_wrapper.h"
    substituteInPlace cmake/libonnxruntime.pc.cmake.in \
      --replace-fail '$'{prefix}/@CMAKE_INSTALL_ @CMAKE_INSTALL_
    substituteInPlace cmake/external/abseil-cpp.cmake \
      --replace-fail \
        "FIND_PACKAGE_ARGS 20240116 NAMES absl" \
        "FIND_PACKAGE_ARGS NAMES absl REQUIRED TARGETS absl_log absl_check" \
      --replace-fail \
        "onnxruntime_fetchcontent_makeavailable" \
        "FetchContent_MakeAvailable"
  '' + lib.optionalString (effectiveStdenv.hostPlatform.system == "aarch64-linux") ''
    # https://github.com/NixOS/nixpkgs/pull/226734#issuecomment-1663028691
    rm -v onnxruntime/test/optimizer/nhwc_transformer_test.cc
  '';

  postBuild = lib.optionalString pythonSupport ''
    ${python3Packages.python.interpreter} ../setup.py bdist_wheel
  '';

  postInstall = ''
    # perform parts of `tools/ci_build/github/linux/copy_strip_binary.sh`
    install -m644 -Dt $out/include \
      ../include/onnxruntime/core/framework/provider_options.h \
      ../include/onnxruntime/core/providers/cpu/cpu_provider_factory.h \
      ../include/onnxruntime/core/session/onnxruntime_*.h
  '';

  passthru = {
    inherit cudaSupport cudaPackages; # for the python module
    protobuf = protobuf;
    tests = lib.optionalAttrs pythonSupport {
      python = python3Packages.onnxruntime;
    };
  };

  meta = with lib; {
    description = "Cross-platform, high performance scoring engine for ML models";
    longDescription = ''
      ONNX Runtime is a performance-focused complete scoring engine
      for Open Neural Network Exchange (ONNX) models, with an open
      extensible architecture to continually address the latest developments
      in AI and Deep Learning. ONNX Runtime stays up to date with the ONNX
      standard with complete implementation of all ONNX operators, and
      supports all ONNX releases (1.2+) with both future and backwards
      compatibility.
    '';
    homepage = "https://github.com/microsoft/onnxruntime";
    changelog = "https://github.com/microsoft/onnxruntime/releases/tag/v${version}";
    # https://github.com/microsoft/onnxruntime/blob/master/BUILD.md#architectures
    platforms = platforms.unix;
    license = licenses.mit;
    maintainers = with maintainers; [ puffnfresh ck3d cbourjau ];
  };
}
