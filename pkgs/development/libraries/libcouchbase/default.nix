{ stdenv, fetchFromGitHub, cmake, pkgconfig, libevent, openssl}:

stdenv.mkDerivation rec {
  name = "libcouchbase-${version}";
  version = "2.8.5";

  src = fetchFromGitHub {
    owner = "couchbase";
    repo = "libcouchbase";
    rev = version;
    sha256 = "1iwzf0y5f25g5hgdkmv6qf3k5mzlazrpx5sj3m2pvrl9jg9wn4s1";
  };

  cmakeFlags = "-DLCB_NO_MOCK=ON";

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ libevent openssl ];

  doCheck = true;
  checkPhase = "ctest";

  meta = with stdenv.lib; {
    description = "C client library for Couchbase";
    homepage = https://github.com/couchbase/libcouchbase;
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
