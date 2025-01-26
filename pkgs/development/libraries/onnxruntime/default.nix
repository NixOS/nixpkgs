{ config
, stdenv
, lib
, fetchFromGitHub
, fetchpatch2
, Foundation
, abseil-cpp_202401
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
, protobuf_21
, pythonSupport ? true
, cudaSupport ? config.cudaSupport
, ncclSupport ? config.cudaSupport
, cudaPackages ? {}
}@inputs:


let
  version = "1.18.1";

  abseil-cpp = abseil-cpp_202401;

  stdenv = throw "Use effectiveStdenv instead";
  effectiveStdenv = if cudaSupport then cudaPackages.backendStdenv else inputs.stdenv;

  cudaArchitecturesString = cudaPackages.flags.cmakeCudaArchitecturesString;

  howard-hinnant-date = fetchFromGitHub {
    owner = "HowardHinnant";
    repo = "date";
    rev = "v3.0.1";
    sha256 = "sha256-ZSjeJKAcT7mPym/4ViDvIR9nFMQEBCSUtPEuMO27Z+I=";
  };

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

  onnx = fetchFromGitHub {
    owner = "onnx";
    repo = "onnx";
    rev = "refs/tags/v1.16.1";
    hash = "sha256-I1wwfn91hdH3jORIKny0Xc73qW2P04MjkVCgcaNnQUE=";
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
    hash = "sha256-+zWtbLKekGhwdBU3bm1u2F7rYejQ62epE+HcHj05/8A=";
    fetchSubmodules = true;
  };

  patches = [
    # If you stumble on these patches trying to update onnxruntime, check
    # `git blame` and ping the introducers.

    # Context: we want the upstream to
    # - always try find_package first (FIND_PACKAGE_ARGS),
    # - use MakeAvailable instead of the low-level Populate,
    # - use Eigen3::Eigen as the target name (as declared by libeigen/eigen).
    ./0001-eigen-allow-dependency-injection.patch
    # Incorporate a patch that has landed upstream which exposes new
    # 'abseil-cpp' libraries & modifies the 're2' CMakeLists to fix a
    # configuration error that around missing 'gmock' exports.
    #
    # TODO: Check if it can be dropped after 1.19.0
    # https://github.com/microsoft/onnxruntime/commit/b522df0ae477e59f60acbe6c92c8a64eda96cace
    ./update-re2.patch
    # fix `error: template-id not allowed for constructor in C++20`
    (fetchpatch2 {
      name = "suppress-gcc-warning-in-TreeEnsembleAggregator.patch";
      url = "https://github.com/microsoft/onnxruntime/commit/10883d7997ed4b53f989a49bd4387c5769fbd12f.patch?full_index=1";
      hash = "sha256-NgvuCHE7axaUtZIjtQvDpagr+QtHdyL7xXkPQwZbhvY=";
    })
  ] ++ lib.optionals cudaSupport [
    # We apply the referenced 1064.patch ourselves to our nix dependency.
    #  FIND_PACKAGE_ARGS for CUDA was added in https://github.com/microsoft/onnxruntime/commit/87744e5 so it might be possible to delete this patch after upgrading to 1.17.0
    ./nvcc-gsl.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    python3Packages.python
    protobuf_21
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
    "-DABSL_ENABLE_INSTALL=ON"
    "-DFETCHCONTENT_FULLY_DISCONNECTED=ON"
    "-DFETCHCONTENT_QUIET=OFF"
    "-DFETCHCONTENT_SOURCE_DIR_ABSEIL_CPP=${abseil-cpp.src}"
    "-DFETCHCONTENT_SOURCE_DIR_DATE=${howard-hinnant-date}"
    "-DFETCHCONTENT_SOURCE_DIR_FLATBUFFERS=${flatbuffers_23.src}"
    "-DFETCHCONTENT_SOURCE_DIR_GOOGLETEST=${gtest.src}"
    "-DFETCHCONTENT_SOURCE_DIR_GOOGLE_NSYNC=${nsync.src}"
    "-DFETCHCONTENT_SOURCE_DIR_MP11=${mp11}"
    "-DFETCHCONTENT_SOURCE_DIR_ONNX=${onnx}"
    "-DFETCHCONTENT_SOURCE_DIR_RE2=${re2.src}"
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
    NIX_CFLAGS_COMPILE = "-Wno-error";
  };

  # aarch64-linux fails cpuinfo test, because /sys/devices/system/cpu/ does not exist in the sandbox
  doCheck = !(cudaSupport || effectiveStdenv.buildPlatform.system == "aarch64-linux");

  requiredSystemFeatures = lib.optionals cudaSupport [ "big-parallel" ];

  postPatch = ''
    substituteInPlace cmake/libonnxruntime.pc.cmake.in \
      --replace-fail '$'{prefix}/@CMAKE_INSTALL_ @CMAKE_INSTALL_
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
    protobuf = protobuf_21;
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
