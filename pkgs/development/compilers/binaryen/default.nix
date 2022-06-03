{ lib, stdenv, cmake, python3, fetchFromGitHub, emscripten,
  gtest, lit, nodejs, filecheck
}:

stdenv.mkDerivation rec {
  pname = "binaryen";
  version = "108";

  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "binaryen";
    rev = "version_${version}";
    sha256 = "sha256-KGrzAME2Gt4WFIcBJ4L6k4DtE+OtuH4KFbEMPe+f+pA=";
  };

  nativeBuildInputs = [ cmake python3 ];

  preConfigure = ''
    if [ $doCheck -eq 1 ]; then
      sed -i '/googletest/d' third_party/CMakeLists.txt
    else
      cmakeFlagsArray=($cmakeFlagsArray -DBUILD_TESTS=0)
    fi
  '';

  checkInputs = [ gtest lit nodejs filecheck ];
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
  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/WebAssembly/binaryen";
    description = "Compiler infrastructure and toolchain library for WebAssembly, in C++";
    platforms = platforms.all;
    maintainers = with maintainers; [ asppsa ];
    license = licenses.asl20;
    broken = stdenv.isDarwin;
  };

  passthru.tests = {
    inherit emscripten;
  };
}
