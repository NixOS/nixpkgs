{ lib, stdenv, cmake, python3, fetchFromGitHub, emscripten }:

stdenv.mkDerivation rec {
  pname = "binaryen";
  version = "99";

  src = fetchFromGitHub {
    owner = "WebAssembly";
    repo = "binaryen";
    rev = "version_${version}";
    sha256 = "1a6ixxm1f8mrr9mn6a0pimajdzsdr4w1qhr92skxq67168vvc1ic";
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
