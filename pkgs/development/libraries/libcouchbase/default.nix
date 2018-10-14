{ stdenv, fetchFromGitHub, cmake, pkgconfig, libevent, openssl}:

stdenv.mkDerivation rec {
  name = "libcouchbase-${version}";
  version = "2.9.5";

  src = fetchFromGitHub {
    owner = "couchbase";
    repo = "libcouchbase";
    rev = version;
    sha256 = "18l3579b47l8d6nhv0xls8pybkqdmdkw8jg4inalnx3g7ydqfn00";
  };

  cmakeFlags = "-DLCB_NO_MOCK=ON";

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ libevent openssl ];

  doCheck = !stdenv.isDarwin;
  checkPhase = "ctest";

  meta = with stdenv.lib; {
    description = "C client library for Couchbase";
    homepage = https://github.com/couchbase/libcouchbase;
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
