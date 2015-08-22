{ autoconf, automake114x, fetchzip, libtool, perl, stdenv, which }:

let
  version = "1.1.10";
in

stdenv.mkDerivation rec {
  name = "libbson-${version}";

  src = fetchzip {
    url = "https://github.com/mongodb/libbson/releases/download/${version}/libbson-${version}.tar.gz";
    sha256 = "0zzca7zqvxf89fq7ji9626q8nnqyyh0dnmbk4xijzr9sq485xz0s";
  };

  buildInputs = [ autoconf automake114x libtool perl which ];

  meta = with stdenv.lib; {
    description = "A C Library for parsing, editing, and creating BSON documents";
    homepage = "https://github.com/mongodb/libbson";
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
