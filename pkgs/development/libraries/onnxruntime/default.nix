{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, fetchurl
, pkg-config
, cmake
, python3
, libpng
, zlib
, eigen
, protobuf
, howard-hinnant-date
, nlohmann_json
, boost
, oneDNN
, gtest
}:

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
    python3
    gtest
  ];

  buildInputs = [
    libpng
    zlib
    protobuf
    howard-hinnant-date
    nlohmann_json
    boost
    oneDNN
  ];

  # TODO: build server, and move .so's to lib output
  outputs = [ "out" "dev" ];

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
  ];

  doCheck = true;

  postPatch = ''
    substituteInPlace cmake/external/abseil-cpp.cmake \
      --replace "${abseil.url}" "${abseil}"
  '';

  postInstall = ''
    # perform parts of `tools/ci_build/github/linux/copy_strip_binary.sh`
    install -m644 -Dt $out/include \
      ../include/onnxruntime/core/framework/provider_options.h \
      ../include/onnxruntime/core/providers/cpu/cpu_provider_factory.h \
      ../include/onnxruntime/core/session/onnxruntime_*.h
  '';

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
