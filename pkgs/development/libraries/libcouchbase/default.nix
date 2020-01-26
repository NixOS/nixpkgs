{ stdenv, fetchFromGitHub, cmake, pkgconfig, libevent, openssl}:

stdenv.mkDerivation rec {
  pname = "libcouchbase";
  version = "2.10.4";

  src = fetchFromGitHub {
    owner = "couchbase";
    repo = "libcouchbase";
    rev = version;
    sha256 = "1yfmcx65aqd5l87scha6kmm2s38n85ci3gg0h6qfs16s3jfi6bw7";
  };

  cmakeFlags = [ "-DLCB_NO_MOCK=ON" ];

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ libevent openssl ];

  # Running tests in parallel does not work
  enableParallelChecking = false;

  patches = [ ./0001-Fix-timeouts-in-libcouchbase-testsuite.patch ];

  doCheck = !stdenv.isDarwin;

  meta = with stdenv.lib; {
    description = "C client library for Couchbase";
    homepage = https://github.com/couchbase/libcouchbase;
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
