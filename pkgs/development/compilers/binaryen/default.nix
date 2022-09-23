{ lib, stdenv, cmake, python3, fetchFromGitHub, emscripten,
  gtest, lit, nodejs, filecheck, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "binaryen";
  version = "109";

  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "binaryen";
    rev = "version_${version}";
    sha256 = "sha256-HMPoiuTvYhTDaBUfSOfh/Dt4FdO9jGqUaFpi92pnscI=";
  };

  patches = [
    # https://github.com/WebAssembly/binaryen/pull/4321
    (fetchpatch {
      url = "https://github.com/WebAssembly/binaryen/commit/93b8849d9f98ef7ed812938ff0b3219819c2be77.patch";
      sha256 = "sha256-Duan/B9A+occ5Lj2SbRX793xIfhzHbdYPI5PyTNCZoU=";
    })
    # https://github.com/WebAssembly/binaryen/pull/4913
    (fetchpatch {
      url = "https://github.com/WebAssembly/binaryen/commit/b70fe755aa4c90727edfd91dc0a9a51febf0239d.patch";
      sha256 = "sha256-kjPLbdiMVQepSJ7J1gK6dRSMI/2SsH39k7W5AMOIrkM=";
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
