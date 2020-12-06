{ fetchFromGitHub, perl, stdenv, cmake }:

stdenv.mkDerivation rec {
  pname = "libbson";
  version = "1.9.5";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "libbson";
    rev = version;
    sha256 = "16rmzxhhmbvhp4q6qac5j9c74z2pcg5raag5w16mynzikdd2l05b";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ perl ];

  meta = with stdenv.lib; {
    description = "A C Library for parsing, editing, and creating BSON documents";
    homepage = "https://github.com/mongodb/libbson";
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
