{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "catch-${version}";
  version = "1.9.6";

  src = fetchFromGitHub {
    owner = "philsquared";
    repo = "Catch";
    rev = "v${version}";
    sha256 = "0nqnyw6haa2771748ycag4hhjb8ni32cv4f7w3h0pji212542xan";
  };

  nativeBuildInputs = [ cmake ];
  cmakeFlags = [ "-DUSE_CPP14=ON" ];

  doCheck = true;
  checkTarget = "test";

  meta = with stdenv.lib; {
    description = "A multi-paradigm automated test framework for C++ and Objective-C (and, maybe, C)";
    homepage = http://catch-lib.net;
    license = licenses.boost;
    maintainers = with maintainers; [ edwtjo knedlsepp ];
    platforms = with platforms; unix;
  };
}
