{ stdenv, fetchzip, autoconf, automake114x, perl, pkgconfig, libbson, libtool
, openssl, which
}:

let
  version = "1.1.10";
in

stdenv.mkDerivation rec {
  name = "mongoc-${version}";

  src = fetchzip {
    url = "https://github.com/mongodb/mongo-c-driver/releases/download/${version}/mongo-c-driver-${version}.tar.gz";
    sha256 = "13yg8dpqgbpc44lsblr3szk2a5bnl2prlayv4xlkivx90m86lcx3";
  };

  propagatedBuildInputs = [ libbson ];
  buildInputs = [ autoconf automake114x libtool openssl perl pkgconfig which ];

  meta = with stdenv.lib; {
    description = "The official C client library for MongoDB";
    homepage = "https://github.com/mongodb/mongo-c-driver";
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
