{ stdenv, fetchurl, cmake, pkgconfig, libevent, openssl}:

stdenv.mkDerivation {
  name = "libcouchbase-2.5.2";
  src = fetchurl {
    url = "https://github.com/couchbase/libcouchbase/archive/2.5.2.tar.gz";
    sha256 = "0ka1hix38a2kdhxz6n8frssyznf78ra0irga9d8lr5683y73xw24";
  };

  cmakeFlags = "-DLCB_NO_MOCK=ON";

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ libevent openssl];

  meta = {
    description = "C client library for Couchbase";
    homepage = "https://github.com/couchbase/libcouchbase";
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.unix;
  };
}
