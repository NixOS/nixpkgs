{ stdenv, cmake, python3, fetchFromGitHub, fetchpatch, emscripten }:

stdenv.mkDerivation rec {
  pname = "binaryen";
  version = "96";

  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "binaryen";
    rev = "version_${version}";
    sha256 = "1mqpb6yy87aifpbcy0lczi3bp6kddrwi6d0g6lrhjrdxx2kvbdag";
  };

  patches = [
    # Adds --minimize-wasm-changes option required by emscripten 2.0.1
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/WebAssembly/binaryen/pull/3044.patch";
      sha256 = "1hdbc9h9zhh2d3bl4sqv6v9psfmny715612bwpjdln0ibdvc129s";
    })
  ];

  nativeBuildInputs = [ cmake python3 ];

  meta = with stdenv.lib; {
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
