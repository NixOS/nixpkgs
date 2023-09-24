{ lib
, stdenv
, fetchFromGitHub
, cmake
, cunit
, ncurses
, quictls
, withJemalloc ? false
, jemalloc
, curlHTTP3
}:

stdenv.mkDerivation rec {
  pname = "ngtcp2";
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "ngtcp2";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-agiQRy/e5VS+ANxajXYi5huRjQQ2M8eddH/AzmwnHdQ=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ quictls ] ++ lib.optional withJemalloc jemalloc;

  doCheck = true;
  nativeCheckInputs = [ cunit ncurses ];

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
