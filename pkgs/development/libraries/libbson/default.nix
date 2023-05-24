{ fetchFromGitHub, perl, lib, stdenv, cmake }:

stdenv.mkDerivation rec {
  pname = "libbson";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "mongodb";
    repo = "mongo-c-driver";
    rev = version;
    sha256 = "sha256-15YKd5zfvEpsPpJX5DtXhDl3kErMGfCCGNAhQul01nk=";
  };

  cmakeFlags = [
    "-DENABLE_MONGOC=OFF"
    "-DENABLE_BSON=ON"
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ perl ];

  meta = with lib; {
    description = "A C Library for parsing, editing, and creating BSON documents";
    homepage = "https://github.com/mongodb/libbson";
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
