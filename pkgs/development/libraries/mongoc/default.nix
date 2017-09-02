{ stdenv, fetchzip, perl, pkgconfig, libbson
, openssl, which
}:

stdenv.mkDerivation rec {
  name = "mongoc-${version}";
  version = "1.7.0";

  src = fetchzip {
    url = "https://github.com/mongodb/mongo-c-driver/releases/download/${version}/mongo-c-driver-${version}.tar.gz";
    sha256 = "1s0j7wmgdkgawzd75psh5ml35lkx68h6pimqrnfp2z1ggzcwajgn";
  };

  propagatedBuildInputs = [ libbson ];
  buildInputs = [ openssl perl pkgconfig which ];

  meta = with stdenv.lib; {
    description = "The official C client library for MongoDB";
    homepage = https://github.com/mongodb/mongo-c-driver;
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
