{ config
, stdenv
, lib
, fetchFromGitHub
, Foundation
, abseil-cpp_202407
, cmake
, cpuinfo
, eigen
, flatbuffers_23
, gbenchmark
, glibcLocales
, gtest
, howard-hinnant-date
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
  version = "1.20.1";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "onnxruntime";
    tag = "v${version}";
    hash = "sha256-xIjR2HsVIqc78ojSXzoTGIxk7VndGYa8o4pVB8U8oXI=";
    fetchSubmodules = true;
  };

  stdenv = throw "Use effectiveStdenv instead";
  effectiveStdenv = if cudaSupport then cudaPackages.backendStdenv else inputs.stdenv;

  cudaArchitecturesString = cudaPackages.flags.cmakeCudaArchitecturesString;

  mp11 = fetchFromGitHub {
    owner = "boostorg";
    repo = "mp11";
    tag = "boost-1.82.0";
    hash = "sha256-cLPvjkf2Au+B19PJNrUkTW/VPxybi1MpPxnIl4oo4/o=";
  };

  safeint = fetchFromGitHub {
    owner = "dcleblanc";
    repo = "safeint";
    tag = "3.0.28";
    hash = "sha256-pjwjrqq6dfiVsXIhbBtbolhiysiFlFTnx5XcX77f+C0=";
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
    tag = "v1.16.1";
    hash = "sha256-+NmWoZDXNJ8YQIWlUXV+czHyI8UtJedu2VG+1aR5L7s=";
    # Apply backport of https://github.com/onnx/onnx/pull/6195 from 1.17.0
    postFetch = ''
      pushd $out
      patch -p1 < ${src}/cmake/patches/onnx/onnx.patch
      popd
    '';
  };

   cutlass = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "cutlass";
    tag = "v3.5.1";
    hash = "sha256-sTGYN+bjtEqQ7Ootr/wvx3P9f8MCDSSj3qyCWjfdLEA=";
 };
in
effectiveStdenv.mkDerivation rec {
  pname = "onnxruntime";
  inherit src version;

  patches = [
    # If you stumble on these patches trying to update onnxruntime, check
    # `git blame` and ping the introducers.

    # Context: we want the upstream to
    # - always try find_package first (FIND_PACKAGE_ARGS),
    # - use MakeAvailable instead of the low-level Populate,
    # - use Eigen3::Eigen as the target name (as declared by libeigen/eigen).
    ./eigen.patch
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
    cudaPackages.cudnn-frontend
  ];

  buildInputs = [
    cpuinfo
    eigen
    glibcLocales
    howard-hinnant-date
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
    "-DFETCHCONTENT_SOURCE_DIR_ABSEIL_CPP=${abseil-cpp_202407.src}"
    "-DFETCHCONTENT_SOURCE_DIR_FLATBUFFERS=${flatbuffers_23.src}"
    "-DFETCHCONTENT_SOURCE_DIR_GOOGLE_NSYNC=${nsync.src}"
    "-DFETCHCONTENT_SOURCE_DIR_MP11=${mp11}"
    "-DFETCHCONTENT_SOURCE_DIR_ONNX=${onnx}"
    "-DFETCHCONTENT_SOURCE_DIR_RE2=${re2.src}"
    "-DFETCHCONTENT_SOURCE_DIR_SAFEINT=${safeint}"
    "-DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS"
    # fails to find protoc on darwin, so specify it
    "-DONNX_CUSTOM_PROTOC_EXECUTABLE=${protobuf_21}/bin/protoc"
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
    echo "find_package(cudnn_frontend REQUIRED)" > cmake/external/cudnn_frontend.cmake

    # https://github.com/microsoft/onnxruntime/blob/c4f3742bb456a33ee9c826ce4e6939f8b84ce5b0/onnxruntime/core/platform/env.h#L249
    substituteInPlace onnxruntime/core/platform/env.h --replace-fail \
      "GetRuntimePath() const { return PathString(); }" \
      "GetRuntimePath() const { return PathString(\"$out/lib/\"); }"
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
