{ stdenv, lib, cmake, fetchFromGitHub }:

stdenv.mkDerivation rec {

  name = "catch-${version}";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "philsquared";
    repo = "Catch";
    rev = "v." + version;
    sha256 = "0harki6irc4mqipjc24zyy0jimidr5ng3ss29bnpzbbwhrnkyrgm";
  };

  buildInputs = [ cmake ];
  dontUseCmakeConfigure = true;

  buildPhase = ''
    cmake . -BBuild -DCMAKE_BUILD_TYPE=Release -DUSE_CPP11=ON
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
