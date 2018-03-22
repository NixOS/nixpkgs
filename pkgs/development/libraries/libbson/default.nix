{ fetchFromGitHub, perl, stdenv, cmake }:

stdenv.mkDerivation rec {
  name = "libbson-${version}";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "libbson";
    rev = version;
    sha256 = "1dlmcqsb43269z4pa3xmqb1gf1jsji82sk5yyibq0ndhk326iyck";
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
