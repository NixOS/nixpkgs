{ stdenv
, lib
, fetchFromGitHub
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

let
  # prefetch abseil
  # Note: keep URL in sync with `cmake/external/abseil-cpp.cmake`
  abseil = fetchurl {
    url = "https://github.com/abseil/abseil-cpp/archive/refs/tags/20211102.0.zip";
    sha256 = "sha256-pFZ/8C+spnG5XjHTFbqxi0K2xvGmDpHG6oTlohQhEsI=";
  };
in
stdenv.mkDerivation rec {
  pname = "onnxruntime";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "onnxruntime";
    rev = "v${version}";
    sha256 = "sha256-wwllEemiHTp9aJcCd1gsTS4WUVMp5wW+4i/+6DzmAeM=";
    fetchSubmodules = true;
  };

  patches = [
    # Use dnnl from nixpkgs instead of submodules
    (fetchpatch {
      name = "system-dnnl.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/system-dnnl.diff?h=python-onnxruntime&id=0185531906bda3a9aba93bbb0f3dcfeb0ae671ad";
      sha256 = "sha256-58RBrQnAWNtc/1pmFs+PkZ6qCsL1LfMY3P0exMKzotA=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    python3Packages.python
    gtest
  ] ++ lib.optionals pythonSupport (with python3Packages; [
    setuptools
    wheel
    pip
    pythonOutputDistHook
  ]);

  buildInputs = [
    libpng
    zlib
    howard-hinnant-date
    nlohmann_json
    boost
    oneDNN
    protobuf
  ] ++ lib.optionals pythonSupport [
    nsync
    python3Packages.numpy
    python3Packages.pybind11
  ];

  # TODO: build server, and move .so's to lib output
  # Python's wheel is stored in a separate dist output
  outputs = [ "out" "dev" ] ++ lib.optionals pythonSupport [ "dist" ];

  enableParallelBuilding = true;

  cmakeDir = "../cmake";

  cmakeFlags = [
    "-Donnxruntime_PREFER_SYSTEM_LIB=ON"
    "-Donnxruntime_BUILD_SHARED_LIB=ON"
    "-Donnxruntime_ENABLE_LTO=ON"
    "-Donnxruntime_BUILD_UNIT_TESTS=ON"
    "-Donnxruntime_USE_PREINSTALLED_EIGEN=ON"
    "-Donnxruntime_USE_MPI=ON"
    "-Deigen_SOURCE_PATH=${eigen.src}"
    "-Donnxruntime_USE_DNNL=YES"
  ] ++ lib.optionals pythonSupport [
    "-Donnxruntime_ENABLE_PYTHON=ON"
  ];

  doCheck = true;

  postPatch = ''
    substituteInPlace cmake/external/abseil-cpp.cmake \
      --replace "${abseil.url}" "${abseil}"

    substituteInPlace cmake/libonnxruntime.pc.cmake.in \
      --replace '$'{prefix}/@CMAKE_INSTALL_ @CMAKE_INSTALL_
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
    inherit protobuf;
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
    maintainers = with maintainers; [ jonringer puffnfresh ck3d ];
  };
}
