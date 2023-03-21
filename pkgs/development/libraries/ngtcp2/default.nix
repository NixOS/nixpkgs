{ lib, stdenv, fetchFromGitHub
, cmake
, libev, nghttp3, quictls
, cunit, ncurses
, withJemalloc ? false, jemalloc
, curlHTTP3
}:

stdenv.mkDerivation rec {
  pname = "ngtcp2";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "ngtcp2";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-bkTbnf7vyTxA623JVGUgrwAuXK7d8kzijOK1F4Sh4yY=";
  };

  outputs = [ "out" "dev" "doc" ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libev nghttp3 quictls ] ++ lib.optional withJemalloc jemalloc;
  nativeCheckInputs = [ cunit ncurses ];

  cmakeFlags = [
    "-DENABLE_STATIC_LIB=OFF"
  ];

  doCheck = true;
  enableParallelBuilding = true;

  passthru.tests = {
    inherit curlHTTP3;
  };

  meta = with lib; {
    homepage = "https://github.com/ngtcp2/ngtcp2";
    description = "ngtcp2 project is an effort to implement QUIC protocol which is now being discussed in IETF QUICWG for its standardization.";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ izorkin ];
  };
}
