{ lib, stdenv, cmake, python3, fetchFromGitHub, emscripten }:

stdenv.mkDerivation rec {
  pname = "binaryen";
  version = "101";

  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "binaryen";
    rev = "version_${version}";
    sha256 = "sha256-rNiZQIQqNbc1P2A6UTn0dRHeT3BS+nv1o81aPaJy+5U=";
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
