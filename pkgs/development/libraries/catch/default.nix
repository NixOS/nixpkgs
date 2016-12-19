{ stdenv, lib, cmake, fetchFromGitHub }:

stdenv.mkDerivation rec {

  name = "catch-${version}";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "philsquared";
    repo = "Catch";
    rev = "v" + version;
    sha256 = "1ag8siafg7fmb50qdqznryrg3lvv56f09nvqwqqn2rlk83zjnaw0";
  };

  buildInputs = [ cmake ];
  dontUseCmakeConfigure = true;

  buildPhase = ''
    cmake -Hprojects/CMake -BBuild -DCMAKE_BUILD_TYPE=Release -DUSE_CPP11=ON
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
    platforms = with platforms; unix;
  };
}
