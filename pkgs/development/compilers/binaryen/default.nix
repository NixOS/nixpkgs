{ lib, stdenv, cmake, python3, fetchFromGitHub, fetchpatch, emscripten }:

stdenv.mkDerivation rec {
  pname = "binaryen";
  version = "101";

  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "binaryen";
    rev = "version_${version}";
    sha256 = "15gvfai3snndlgsppyjjf17xw4bmyhwm2fk07wsvfd9ahi09kn5c";
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
