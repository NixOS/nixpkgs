{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "catch2";
  version = "2.10.2";

  src = fetchFromGitHub {
    owner = "catchorg";
    repo = "Catch2";
    rev = "v${version}";
    sha256="01ldfv4337s3vdhsx415d49jchpvqy61c77dhnri30ip5af0ipjs";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-H.." ];

  meta = with stdenv.lib; {
    description = "A multi-paradigm automated test framework for C++ and Objective-C (and, maybe, C)";
    homepage = "http://catch-lib.net";
    license = licenses.boost;
    maintainers = with maintainers; [ edwtjo knedlsepp ];
    platforms = with platforms; unix;
  };
}
