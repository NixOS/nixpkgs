{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "catch";
  version = "3.0.0-preview3";

  src = fetchFromGitHub {
    owner = "catchorg";
    repo = "Catch";
    rev = "v${version}";
    sha256 = "06bmwrd9bsfngxj04id9rxmppqpnalsk11kgh823xdsa72sh44xg";
  };

  nativeBuildInputs = [ cmake ];
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
