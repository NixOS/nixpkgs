{ stdenv, fetchzip, autoconf, automake114x, perl, pkgconfig, libbson, libtool
, openssl, which
}:

stdenv.mkDerivation rec {
  name = "mongoc-${version}";
  version = "1.5.4";

  src = fetchzip {
    url = "https://github.com/mongodb/mongo-c-driver/releases/download/${version}/mongo-c-driver-${version}.tar.gz";
    sha256 = "0xjk3k76n8yz7zi6a0dx1wgpsvvn5qhpzrapdw4v3h49hwf7rc5q";
  };

  propagatedBuildInputs = [ libbson ];
  buildInputs = [ autoconf automake114x libtool openssl perl pkgconfig which ];

  meta = with stdenv.lib; {
    description = "The official C client library for MongoDB";
    homepage = https://github.com/mongodb/mongo-c-driver;
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
