{ fetchFromGitHub, perl, stdenv, cmake }:

stdenv.mkDerivation rec {
  name = "libbson-${version}";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "libbson";
    rev = version;
    sha256 = "1ilxbv4yjgf0vfzaa8lzn40hv5x1737ny2g2q1wmm8bl39m0viiw";
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
