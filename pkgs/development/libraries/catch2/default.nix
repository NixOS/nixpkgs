{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "catch2-${version}";
  version = "2.9.1";

  src = fetchFromGitHub {
    owner = "catchorg";
    repo = "Catch2";
    rev = "v${version}";
    sha256="17kb29wfrqm93wgx8q8v1vpv9fx9v5yfv6qf2nn1irjznbxs1dx2";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-H.." ];

  meta = with stdenv.lib; {
    description = "A multi-paradigm automated test framework for C++ and Objective-C (and, maybe, C)";
    homepage = http://catch-lib.net;
    license = licenses.boost;
    maintainers = with maintainers; [ edwtjo knedlsepp ];
    platforms = with platforms; unix;
  };
}
