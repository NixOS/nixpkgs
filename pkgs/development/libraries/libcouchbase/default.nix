{ stdenv, fetchFromGitHub, cmake, pkgconfig, libevent, openssl}:

stdenv.mkDerivation rec {
  name = "libcouchbase-${version}";
  version = "2.9.2";

  src = fetchFromGitHub {
    owner = "couchbase";
    repo = "libcouchbase";
    rev = version;
    sha256 = "1ca3jp1nr5dk2w35wwyhsf96pblbw6n6n7a3ja264ivc9nhpkz4z";
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
