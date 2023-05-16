{ stdenv
, lib
, fetchFromGitHub
<<<<<<< HEAD
, fetchFromGitLab
, fetchpatch
, fetchurl
, Foundation
, abseil-cpp
, cmake
, libpng
, nlohmann_json
, nsync
, pkg-config
, python3Packages
, re2
, zlib
, microsoft-gsl
, iconv
, gtest
, protobuf3_21
, pythonSupport ? true
}:


let
  howard-hinnant-date = fetchFromGitHub {
    owner = "HowardHinnant";
    repo = "date";
    rev = "v2.4.1";
    sha256 = "sha256-BYL7wxsYRI45l8C3VwxYIIocn5TzJnBtU0UZ9pHwwZw=";
  };

  eigen = fetchFromGitLab {
    owner = "libeigen";
    repo = "eigen";
    rev = "d10b27fe37736d2944630ecd7557cefa95cf87c9";
    sha256 = "sha256-Lmco0s9gIm9sIw7lCr5Iewye3RmrHEE4HLfyzRkQCm0=";
  };

  mp11 = fetchFromGitHub {
    owner = "boostorg";
    repo = "mp11";
    rev = "boost-1.79.0";
    sha256 = "sha256-ZxgPDLvpISrjpEHKpLGBowRKGfSwTf6TBfJD18yw+LM=";
  };

  safeint = fetchFromGitHub {
    owner = "dcleblanc";
    repo = "safeint";
    rev = "ff15c6ada150a5018c5ef2172401cb4529eac9c0";
    sha256 = "sha256-PK1ce4C0uCR4TzLFg+elZdSk5DdPCRhhwT3LvEwWnPU=";
  };

  pytorch_cpuinfo = fetchFromGitHub {
    owner = "pytorch";
    repo = "cpuinfo";
    # There are no tags in the repository
    rev = "5916273f79a21551890fd3d56fc5375a78d1598d";
    sha256 = "sha256-nXBnloVTuB+AVX59VDU/Wc+Dsx94o92YQuHp3jowx2A=";
  };

  flatbuffers = fetchFromGitHub {
    owner = "google";
    repo = "flatbuffers";
    rev = "v1.12.0";
    sha256 = "sha256-L1B5Y/c897Jg9fGwT2J3+vaXsZ+lfXnskp8Gto1p/Tg=";
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
in
stdenv.mkDerivation rec {
  pname = "onnxruntime";
  version = "1.15.1";
=======
, fetchpatch
, fetchurl
, pkg-config
, cmake
, python3Packages
, libpng
, zlib
, eigen
, protobuf
, howard-hinnant-date
, nlohmann_json
, boost
, oneDNN
, abseil-cpp_202111
, gtest
, pythonSupport ? false
, nsync
, flatbuffers
}:

# Python Support
#
# When enabling Python support a wheel is made and stored in a `dist` output.
# This wheel is then installed in a separate derivation.

assert pythonSupport -> lib.versionOlder protobuf.version "3.20";

stdenv.mkDerivation rec {
  pname = "onnxruntime";
  version = "1.13.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "onnxruntime";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-SnHo2sVACc++fog7Tg6f2LK/Sv/EskFzN7RZS7D113s=";
    fetchSubmodules = true;
  };

=======
    sha256 = "sha256-paaeq6QeiOzwiibbz0GkYZxEI/V80lvYNYTm6AuyAXQ=";
    fetchSubmodules = true;
  };

  patches = [
    # Use dnnl from nixpkgs instead of submodules
    (fetchpatch {
      name = "system-dnnl.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/system-dnnl.diff?h=python-onnxruntime&id=9c392fb542979981fe0026e0fe3cc361a5f00a36";
      sha256 = "sha256-+kedzJHLFU1vMbKO9cn8fr+9A5+IxIuiqzOfR2AfJ0k=";
    })
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [
    cmake
    pkg-config
    python3Packages.python
<<<<<<< HEAD
    protobuf3_21
=======
    gtest
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ] ++ lib.optionals pythonSupport (with python3Packages; [
    setuptools
    wheel
    pip
    pythonOutputDistHook
  ]);

  buildInputs = [
    libpng
    zlib
<<<<<<< HEAD
    nlohmann_json
    nsync
    re2
    microsoft-gsl
  ] ++ lib.optionals pythonSupport [
    python3Packages.numpy
    python3Packages.pybind11
    python3Packages.packaging
  ] ++ lib.optionals stdenv.isDarwin [
    Foundation
    iconv
  ];

  nativeCheckInputs = lib.optionals pythonSupport (with python3Packages; [
    gtest'
    pytest
    sympy
    onnx
  ]);

=======
    howard-hinnant-date
    nlohmann_json
    boost
    oneDNN
    protobuf
  ] ++ lib.optionals pythonSupport [
    nsync
    python3Packages.numpy
    python3Packages.pybind11
    python3Packages.packaging
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # TODO: build server, and move .so's to lib output
  # Python's wheel is stored in a separate dist output
  outputs = [ "out" "dev" ] ++ lib.optionals pythonSupport [ "dist" ];

  enableParallelBuilding = true;

  cmakeDir = "../cmake";

  cmakeFlags = [
<<<<<<< HEAD
    "-DABSL_ENABLE_INSTALL=ON"
    "-DCMAKE_BUILD_TYPE=RELEASE"
    "-DFETCHCONTENT_FULLY_DISCONNECTED=ON"
    "-DFETCHCONTENT_QUIET=OFF"
    "-DFETCHCONTENT_SOURCE_DIR_ABSEIL_CPP=${abseil-cpp.src}"
    "-DFETCHCONTENT_SOURCE_DIR_DATE=${howard-hinnant-date}"
    "-DFETCHCONTENT_SOURCE_DIR_EIGEN=${eigen}"
    "-DFETCHCONTENT_SOURCE_DIR_FLATBUFFERS=${flatbuffers}"
    "-DFETCHCONTENT_SOURCE_DIR_GOOGLE_NSYNC=${nsync.src}"
    "-DFETCHCONTENT_SOURCE_DIR_MP11=${mp11}"
    "-DFETCHCONTENT_SOURCE_DIR_ONNX=${python3Packages.onnx.src}"
    "-DFETCHCONTENT_SOURCE_DIR_PYTORCH_CPUINFO=${pytorch_cpuinfo}"
    "-DFETCHCONTENT_SOURCE_DIR_RE2=${re2.src}"
    "-DFETCHCONTENT_SOURCE_DIR_SAFEINT=${safeint}"
    "-DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS"
    "-Donnxruntime_BUILD_SHARED_LIB=ON"
    "-Donnxruntime_BUILD_UNIT_TESTS=ON"
    "-Donnxruntime_ENABLE_LTO=ON"
    "-Donnxruntime_USE_FULL_PROTOBUF=OFF"
=======
    "-Donnxruntime_PREFER_SYSTEM_LIB=ON"
    "-Donnxruntime_BUILD_SHARED_LIB=ON"
    "-Donnxruntime_ENABLE_LTO=ON"
    "-Donnxruntime_BUILD_UNIT_TESTS=ON"
    "-Donnxruntime_USE_PREINSTALLED_EIGEN=ON"
    "-Donnxruntime_USE_MPI=ON"
    "-Deigen_SOURCE_PATH=${eigen.src}"
    "-DFETCHCONTENT_SOURCE_DIR_ABSEIL_CPP=${abseil-cpp_202111.src}"
    "-Donnxruntime_USE_DNNL=YES"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ] ++ lib.optionals pythonSupport [
    "-Donnxruntime_ENABLE_PYTHON=ON"
  ];

  doCheck = true;

  postPatch = ''
    substituteInPlace cmake/libonnxruntime.pc.cmake.in \
      --replace '$'{prefix}/@CMAKE_INSTALL_ @CMAKE_INSTALL_
<<<<<<< HEAD
  '' + lib.optionalString (stdenv.hostPlatform.system == "aarch64-linux") ''
    # https://github.com/NixOS/nixpkgs/pull/226734#issuecomment-1663028691
    rm -v onnxruntime/test/optimizer/nhwc_transformer_test.cc
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  postBuild = lib.optionalString pythonSupport ''
    python ../setup.py bdist_wheel
  '';

  postInstall = ''
    # perform parts of `tools/ci_build/github/linux/copy_strip_binary.sh`
    install -m644 -Dt $out/include \
      ../include/onnxruntime/core/framework/provider_options.h \
      ../include/onnxruntime/core/providers/cpu/cpu_provider_factory.h \
      ../include/onnxruntime/core/session/onnxruntime_*.h
  '';

  passthru = {
<<<<<<< HEAD
    protobuf = protobuf3_21;
=======
    inherit protobuf;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    maintainers = with maintainers; [ jonringer puffnfresh ck3d cbourjau ];
=======
    maintainers = with maintainers; [ jonringer puffnfresh ck3d ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
