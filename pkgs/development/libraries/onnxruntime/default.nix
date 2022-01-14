{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, runCommand
, patchutils
, pkg-config
, glibcLocales
, cmake
, python3
, libpng
, zlib
, eigen
, protobuf
, nsync
, flatbuffers
, howard-hinnant-date
, re2
, nlohmann_json
, boost
, oneDNN
}:

let
  externals = {
    pytorch_cpuinfo = fetchFromGitHub {
      owner = "pytorch";
      repo = "cpuinfo";
      rev = "5916273f79a21551890fd3d56fc5375a78d1598d";
      sha256 = "sha256-nXBnloVTuB+AVX59VDU/Wc+Dsx94o92YQuHp3jowx2A=";
    };
    onnx = fetchFromGitHub {
      owner = "onnx";
      repo = "onnx";
      rev = "be76ca7148396176784ba8733133b9fb1186ea0d";
      sha256 = "sha256-WwbfUijV67LL69RPgz+4m6EcwSyBNFweGUe0jkYRpbg=";
    };
    "SafeInt/safeint" = fetchFromGitHub {
      owner = "dcleblanc";
      repo = "SafeInt";
      rev = "a104e0cf23be4fe848f7ef1f3e8996fe429b06bb";
      sha256 = "sha256-LmQNIoHPqvl8asn86P33SDn+lCg8LpLfxUmoG9CGEdc=";
    };
  };
in
stdenv.mkDerivation rec {
  pname = "onnxruntime";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "onnxruntime";
    rev = "v${version}";
    sha256 = "sha256-kWl0xrbTQL2FBSvpiqTcaj8uZV+ZV8gJJvj4/I0jopw=";
  };

  preConfigure = lib.concatStringsSep "\n" (lib.mapAttrsToList (name: path: ''
    rmdir cmake/external/${name}
    ln -s ${path} cmake/external/${name}
  '') externals);

  patches = [
    # Exclude the flatbuffers change which breaks things
    (runCommand "filtered" {
      AUR_PATCH = fetchpatch {
        name = "aur-build-fixes.patch";
        url = "https://aur.archlinux.org/cgit/aur.git/plain/build-fixes.patch?h=python-onnxruntime&id=0185531906bda3a9aba93bbb0f3dcfeb0ae671ad";
        sha256 = "sha256-bAJWThTbECQaoqDdkjHLneg6I1BshGMyCWaj7nfACvA=";
      };
    } ''
      ${patchutils}/bin/filterdiff --hunks 1,2 $AUR_PATCH > $out
    '')
    (fetchpatch {
      name = "system-dnnl.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/system-dnnl.diff?h=python-onnxruntime&id=0185531906bda3a9aba93bbb0f3dcfeb0ae671ad";
      sha256 = "sha256-58RBrQnAWNtc/1pmFs+PkZ6qCsL1LfMY3P0exMKzotA=";
    })
  ];

  # TODO: build server, and move .so's to lib output
  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ];

  buildInputs = [
    libpng
    zlib
    protobuf
    nsync
    flatbuffers
    howard-hinnant-date
    re2
    nlohmann_json
    boost
    oneDNN
  ];

  cmakeDir = "../cmake";

  cmakeFlags = [
    "-Donnxruntime_PREFER_SYSTEM_LIB=ON"
    "-Donnxruntime_BUILD_SHARED_LIB=ON"
    "-Donnxruntime_ENABLE_LTO=ON"
    "-Donnxruntime_BUILD_UNIT_TESTS=OFF"
    "-Donnxruntime_USE_PREINSTALLED_EIGEN=ON"
    "-Donnxruntime_USE_MPI=ON"
    "-Deigen_SOURCE_PATH=${eigen.src}"
    "-Donnxruntime_USE_DNNL=YES"
  ];

  enableParallelBuilding = true;

  meta = {
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
    changelog = "https://github.com/microsoft/onnxruntime/releases";
    # https://github.com/microsoft/onnxruntime/blob/master/BUILD.md#architectures
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jonringer puffnfresh ];
  };
}
