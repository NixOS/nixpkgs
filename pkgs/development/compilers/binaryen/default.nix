{ lib, stdenv, cmake, python3, fetchFromGitHub, emscripten,
  gtest, lit, nodejs, filecheck
}:

stdenv.mkDerivation rec {
  pname = "binaryen";
<<<<<<< HEAD
  version = "114";
=======
  version = "112";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "binaryen";
    rev = "version_${version}";
<<<<<<< HEAD
    hash = "sha256-bzHNIQy0AN8mIFGG+638p/MBSqlkWuaOzKGSsMDAPH4=";
=======
    hash = "sha256-xVumVmiLMHJp3SItE8eL8OBPeq58HtOOiK9LL8SP4CQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

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
