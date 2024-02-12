{ stdenv
, lib
, fetchFromGitHub
, fetchFromGitLab
, Foundation
, abseil-cpp
, cmake
, eigen
, gtest
, libpng
, nlohmann_json
, nsync
, pkg-config
, python3Packages
, re2
, zlib
, microsoft-gsl
, iconv
, protobuf_21
, pythonSupport ? true
}:


let
  howard-hinnant-date = fetchFromGitHub {
    owner = "HowardHinnant";
    repo = "date";
    rev = "v2.4.1";
    sha256 = "sha256-BYL7wxsYRI45l8C3VwxYIIocn5TzJnBtU0UZ9pHwwZw=";
  };

  mp11 = fetchFromGitHub {
    owner = "boostorg";
    repo = "mp11";
    rev = "boost-1.79.0";
    hash = "sha256-ZxgPDLvpISrjpEHKpLGBowRKGfSwTf6TBfJD18yw+LM=";
  };

  safeint = fetchFromGitHub {
    owner = "dcleblanc";
    repo = "safeint";
    rev = "ff15c6ada150a5018c5ef2172401cb4529eac9c0";
    hash = "sha256-PK1ce4C0uCR4TzLFg+elZdSk5DdPCRhhwT3LvEwWnPU=";
  };

  pytorch_cpuinfo = fetchFromGitHub {
    owner = "pytorch";
    repo = "cpuinfo";
    # There are no tags in the repository
    rev = "5916273f79a21551890fd3d56fc5375a78d1598d";
    hash = "sha256-nXBnloVTuB+AVX59VDU/Wc+Dsx94o92YQuHp3jowx2A=";
  };

  flatbuffers = fetchFromGitHub {
    owner = "google";
    repo = "flatbuffers";
    rev = "v1.12.0";
    hash = "sha256-L1B5Y/c897Jg9fGwT2J3+vaXsZ+lfXnskp8Gto1p/Tg=";
  };

  gtest' = gtest.overrideAttrs (oldAttrs: rec {
    version = "1.13.0";
    src = fetchFromGitHub {
      owner = "google";
      repo = "googletest";
      rev = "v${version}";
      hash = "sha256-LVLEn+e7c8013pwiLzJiiIObyrlbBHYaioO/SWbItPQ=";
    };
  });

  onnx = fetchFromGitHub {
    owner = "onnx";
    repo = "onnx";
    rev = "refs/tags/v1.14.1";
    hash = "sha256-ZVSdk6LeAiZpQrrzLxphMbc1b3rNUMpcxcXPP8s/5tE=";
  };
in
stdenv.mkDerivation rec {
  pname = "onnxruntime";
  version = "1.16.3";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "onnxruntime";
    rev = "refs/tags/v${version}";
    hash = "sha256-bTW9Pc3rvH+c8VIlDDEtAXyA3sajVyY5Aqr6+SxaMF4=";
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
  ]);

  buildInputs = [
    eigen
    libpng
    zlib
    nlohmann_json
    microsoft-gsl
  ] ++ lib.optionals pythonSupport (with python3Packages; [
    numpy
    pybind11
    packaging
  ]) ++ lib.optionals stdenv.isDarwin [
    Foundation
    iconv
  ];

  nativeCheckInputs = lib.optionals pythonSupport (with python3Packages; [
    gtest'
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
    "-DFETCHCONTENT_SOURCE_DIR_FLATBUFFERS=${flatbuffers}"
    "-DFETCHCONTENT_SOURCE_DIR_GOOGLE_NSYNC=${nsync.src}"
    "-DFETCHCONTENT_SOURCE_DIR_MP11=${mp11}"
    "-DFETCHCONTENT_SOURCE_DIR_ONNX=${onnx}"
    "-DFETCHCONTENT_SOURCE_DIR_PYTORCH_CPUINFO=${pytorch_cpuinfo}"
    "-DFETCHCONTENT_SOURCE_DIR_RE2=${re2.src}"
    "-DFETCHCONTENT_SOURCE_DIR_SAFEINT=${safeint}"
    "-DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS"
    "-Donnxruntime_BUILD_SHARED_LIB=ON"
    "-Donnxruntime_BUILD_UNIT_TESTS=ON"
    "-Donnxruntime_ENABLE_LTO=ON"
    "-Donnxruntime_USE_FULL_PROTOBUF=OFF"
  ] ++ lib.optionals pythonSupport [
    "-Donnxruntime_ENABLE_PYTHON=ON"
  ];

  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=deprecated-declarations"
      "-Wno-error=unused-but-set-variable"
    ];
  };

  doCheck = true;

  postPatch = ''
    substituteInPlace cmake/libonnxruntime.pc.cmake.in \
      --replace-fail '$'{prefix}/@CMAKE_INSTALL_ @CMAKE_INSTALL_
  '' + lib.optionalString (stdenv.hostPlatform.system == "aarch64-linux") ''
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
    maintainers = with maintainers; [ jonringer puffnfresh ck3d cbourjau ];
  };
}
