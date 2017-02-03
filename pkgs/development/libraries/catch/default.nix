{ stdenv, cmake, fetchFromGitHub }:

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
  cmakeFlags = [ "-DUSE_CPP14=ON" ];

  doCheck = true;
  checkTarget = "test";

  meta = with stdenv.lib; {
    description = "A multi-paradigm automated test framework for C++ and Objective-C (and, maybe, C)";
    homepage = "http://catch-lib.net";
    license = licenses.boost;
    maintainers = with maintainers; [ edwtjo knedlsepp ];
    platforms = with platforms; unix;
  };
}
