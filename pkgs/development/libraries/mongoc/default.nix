{ lib, stdenv, fetchzip, perl, pkg-config, libbson
, openssl, which, zlib, snappy
}:

stdenv.mkDerivation rec {
  pname = "mongoc";
  version = "1.8.0";

  src = fetchzip {
    url = "https://github.com/mongodb/mongo-c-driver/releases/download/${version}/mongo-c-driver-${version}.tar.gz";
    sha256 = "1vnnk3pwbcmwva1010bl111kdcdx3yb2w7j7a78hhvrm1k9r1wp8";
  };

  nativeBuildInputs = [ pkg-config which perl ];
  buildInputs = [ openssl zlib ];
  propagatedBuildInputs = [ libbson snappy ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "The official C client library for MongoDB";
    homepage = "http://mongoc.org";
    license = licenses.asl20;
    mainProgram = "mongoc-stat";
    platforms = platforms.all;
  };
}
