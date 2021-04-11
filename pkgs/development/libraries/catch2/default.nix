{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "catch2";
  version = "2.13.5";

  src = fetchFromGitHub {
    owner = "catchorg";
    repo = "Catch2";
    rev = "v${version}";
    sha256="sha256-a4NIXI1K4i5HksvLaOltpZaRkv6qbBQbOqLPqd7oNhQ=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-H.." ];

  meta = with lib; {
    description = "A multi-paradigm automated test framework for C++ and Objective-C (and, maybe, C)";
    homepage = "http://catch-lib.net";
    license = licenses.boost;
    maintainers = with maintainers; [ edwtjo knedlsepp ];
    platforms = with platforms; unix;
  };
}
