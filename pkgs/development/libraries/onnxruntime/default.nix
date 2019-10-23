{ stdenv, fetchFromGitHub, glibcLocales
, cmake, python3
}:

stdenv.mkDerivation rec {
  pname = "onnxruntime";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "onnxruntime";
    rev = "v${version}";
    sha256 = "0s8ylc5xr55490hbz7zn3hnp9dnyp92d320ln8xw5hqkw3mgyr3p";
    # TODO: use nix-versions of grpc, onnx, eigen, googletest, etc.
    # submodules increase src size and compile times significantly
    # not currently feasible due to how integrated cmake build is with git
    fetchSubmodules = true;
  };

  # TODO: build server, and move .so's to lib output
  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    cmake
    python3 # for shared-lib or server
  ];

  cmakeDir = "../cmake";

  cmakeFlags = [
    "-Donnxruntime_USE_OPENMP=ON"
    "-Donnxruntime_BUILD_SHARED_LIB=ON"
    "-Donnxruntime_ENABLE_LTO=ON"
  ];

  # ContribOpTest.StringNormalizerTest sets locale to en_US.UTF-8"
  preCheck = stdenv.lib.optionalString stdenv.isLinux ''
    export LOCALE_ARCHIVE="${glibcLocales}/lib/locale/locale-archive"
  '';
  doCheck = true;

  postInstall = ''
    rm -r $out/bin   # ctest runner
  '';

  meta = with stdenv.lib; {
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
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };

}
