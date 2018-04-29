{ fetchFromGitHub, perl, stdenv, cmake }:

stdenv.mkDerivation rec {
  name = "libbson-${version}";
  version = "1.9.4";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "libbson";
    rev = version;
    sha256 = "01lyikbpqky1ib8g4vhwpb5rjwyzm6g1z24z8m73lk4vcdl65190";
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
