{ lib, stdenv, cmake, python3, fetchFromGitHub, emscripten }:

stdenv.mkDerivation rec {
  pname = "binaryen";
  version = "105";

  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "binaryen";
    rev = "version_${version}";
    sha256 = "0yg9rarjv1gfbq225cj9hnbgx99n5az2m19qwfp8z41dwhh71igm";
  };

  nativeBuildInputs = [ cmake python3 ];

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
