{ stdenv, lib, cmake, fetchFromGitHub }:

stdenv.mkDerivation rec {

  name = "catch-${version}";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "philsquared";
    repo = "Catch";
    rev = "v" + version;
    sha256 = "0rz2nmvvh66x6w2nb7l08vc5x9aqg1qfz2qfiykaz1ybc19fwck2";
  };

  buildInputs = [ cmake ];
  dontUseCmakeConfigure = true;

  buildPhase = ''
    cmake -Hprojects/CMake -BBuild -DCMAKE_BUILD_TYPE=Release
    cd Build
    make
    cd ..
  '';

  installPhase = ''
    mkdir -p $out
    mv include $out/.
  '';

  meta = with stdenv.lib; {
    description = "A multi-paradigm automated test framework for C++ and Objective-C (and, maybe, C)";
    homepage = "http://catch-lib.net";
    license = licenses.boost;
    maintainers = with maintainers; [ edwtjo ];
  };
}
