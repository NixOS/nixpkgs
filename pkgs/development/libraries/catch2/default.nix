{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "catch2";
  version = "2.13.9";

  src = fetchFromGitHub {
    owner = "catchorg";
    repo = "Catch2";
    rev = "v${version}";
    sha256="sha256-G6rMTHvrBJbUaTNkR738YClAn2v2xVBr+tXLjpNzVZg=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-H.." ];

  meta = with lib; {
    description = "A multi-paradigm automated test framework for C++ and Objective-C (and, maybe, C)";
    homepage = "http://catch-lib.net";
    license = licenses.boost;
    maintainers = with maintainers; [ edwtjo knedlsepp ];
    platforms = platforms.unix ++ [ "x86_64-windows" ];
  };
}
