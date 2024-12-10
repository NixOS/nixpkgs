{
  lib,
  stdenv,
  cmake,
  python3,
  fetchFromGitHub,
  emscripten,
  gtest,
  lit,
  nodejs,
  filecheck,
}:

stdenv.mkDerivation rec {
  pname = "binaryen";
  version = "118";

  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "binaryen";
    rev = "version_${version}";
    hash = "sha256-akMW3S2/qUyLK8F77EtnaXPDXvIMpkGfNB2jOD6hQho=";
  };

  nativeBuildInputs = [
    cmake
    python3
  ];

  preConfigure = ''
    if [ $doCheck -eq 1 ]; then
      sed -i '/googletest/d' third_party/CMakeLists.txt
    else
      cmakeFlagsArray=($cmakeFlagsArray -DBUILD_TESTS=0)
    fi
  '';

  nativeCheckInputs = [
    gtest
    lit
    nodejs
    filecheck
  ];
  checkPhase = ''
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD/lib python3 ../check.py $tests
  '';

  tests = [
    "version"
    "wasm-opt"
    "wasm-dis"
    "crash"
    "dylink"
    "ctor-eval"
    "wasm-metadce"
    "wasm-reduce"
    "spec"
    "lld"
    "wasm2js"
    "validator"
    "example"
    "unit"
    # "binaryenjs" "binaryenjs_wasm" # not building this
    "lit"
    "gtest"
  ];
  doCheck = stdenv.hostPlatform.isLinux;

  meta = with lib; {
    homepage = "https://github.com/WebAssembly/binaryen";
    description = "Compiler infrastructure and toolchain library for WebAssembly, in C++";
    platforms = platforms.all;
    maintainers = with maintainers; [
      asppsa
      willcohen
    ];
    license = licenses.asl20;
  };

  passthru.tests = {
    inherit emscripten;
  };
}
