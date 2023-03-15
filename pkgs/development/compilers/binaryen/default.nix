{ lib, stdenv, cmake, python3, fetchFromGitHub, emscripten,
  gtest, lit, nodejs, filecheck, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "binaryen";
  version = "111";

  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "binaryen";
    rev = "version_${version}";
    sha256 = "sha256-wSwLs/YvrH7nswDSbtR6onOMArCdPE2zi6G7oA10U4Y=";
  };

  patches = [
    # https://github.com/WebAssembly/binaryen/pull/5378
    (fetchpatch {
      url = "https://github.com/WebAssembly/binaryen/commit/a96fe1a8422140072db7ad7db421378b87898a0d.patch";
      sha256 = "sha256-Wred1IoRxcQBi0nLBWpiUSgt2ApGoGsq9GkoO3mSS6o=";
    })
    # https://github.com/WebAssembly/binaryen/pull/5391
    (fetchpatch {
      url = "https://github.com/WebAssembly/binaryen/commit/f92350d2949934c0e0ce4a27ec8b799ac2a85e45.patch";
      sha256 = "sha256-fBwdGSIPjF2WKNnD8I0/2hnQvqevdk3NS9fAxutkZG0=";
    })
  ];

  nativeBuildInputs = [ cmake python3 ];

  preConfigure = ''
    if [ $doCheck -eq 1 ]; then
      sed -i '/googletest/d' third_party/CMakeLists.txt
    else
      cmakeFlagsArray=($cmakeFlagsArray -DBUILD_TESTS=0)
    fi
  '';

  nativeCheckInputs = [ gtest lit nodejs filecheck ];
  checkPhase = ''
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD/lib python3 ../check.py $tests
  '';

  tests = [
    "version" "wasm-opt" "wasm-dis"
    "crash" "dylink" "ctor-eval"
    "wasm-metadce" "wasm-reduce" "spec"
    "lld" "wasm2js" "validator"
    "example" "unit"
    # "binaryenjs" "binaryenjs_wasm" # not building this
    "lit" "gtest"
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
