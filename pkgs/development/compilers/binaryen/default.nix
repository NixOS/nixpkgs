{
  lib,
  stdenv,
  cmake,
  python3,
  fetchFromGitHub,
  fetchpatch,
  emscripten,
  gtest,
  lit,
  nodejs,
  filecheck,
}:

stdenv.mkDerivation rec {
  pname = "binaryen";
  version = "116";

  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "binaryen";
    rev = "version_${version}";
    hash = "sha256-gMwbWiP+YDCVafQMBWhTuJGWmkYtnhEdn/oofKaUT08=";
  };

  # FIXME: remove for next release
  patches = [
    (fetchpatch {
      name = "nodejs-20.patch";
      url = "https://github.com/WebAssembly/binaryen/commit/889422e0c92552ff484659f9b41e777ba7ab35c1.patch";
      hash = "sha256-acM8mytL9nhm4np9tpUbd1X0wJ7y308HV2fvgcAW1lY=";
    })

    # Fix fmin tests on gcc-13: https://github.com/WebAssembly/binaryen/pull/5994
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/WebAssembly/binaryen/commit/1e17dfb695a19d5d41f1f88411fbcbc5f2408c8f.patch";
      hash = "sha256-5JZh15CXkg5XdTG8eRJXPwO+zmymYeFjKbHutRPTmlU=";
    })
  ];

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
  doCheck = stdenv.isLinux;

  meta = with lib; {
    homepage = "https://github.com/WebAssembly/binaryen";
    description = "Compiler infrastructure and toolchain library for WebAssembly, in C++";
    platforms = platforms.all;
    maintainers = with maintainers; [ asppsa ];
    license = licenses.asl20;
  };

  passthru.tests = {
    inherit emscripten;
  };
}
