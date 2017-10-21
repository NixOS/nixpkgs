{ fetchFromGitHub, perl, stdenv, cmake }:

stdenv.mkDerivation rec {
  name = "libbson-${version}";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "libbson";
    rev = version;
    sha256 = "1bd9z07q3faq5k4521d9inv0j836w6hrsd0vj2sapjlq8jmqgslg";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ perl ];

  meta = with stdenv.lib; {
    description = "A C Library for parsing, editing, and creating BSON documents";
    homepage = https://github.com/mongodb/libbson;
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
