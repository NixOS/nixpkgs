{ stdenv, fetchFromGitHub, cmake, pkgconfig, libevent, openssl}:

stdenv.mkDerivation rec {
  name = "libcouchbase-${version}";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "couchbase";
    repo = "libcouchbase";
    rev = version;
    sha256 = "12s2iw4akil3hlvsccns7qw2c90yw5h67zj3wq03q938w8xcw0d0";
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
