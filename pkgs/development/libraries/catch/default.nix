{ stdenv, lib, cmake, fetchFromGitHub }:

stdenv.mkDerivation rec {

  name = "catch-${version}";
  version = "1.1-3";

  src = fetchFromGitHub {
    owner = "philsquared";
    repo = "Catch";
    rev = "c51e86819dc993d590e5d0adaf1952f4b53e5355";
    sha256 = "0kgi7wxxysgjbpisqfj4dj0k19cyyai92f001zi8gzkybd4fkgv5";
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
