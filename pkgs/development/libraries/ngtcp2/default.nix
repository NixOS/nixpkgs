{ lib, stdenv, fetchFromGitHub
, cmake
, libev, nghttp3, quictls
, cunit, ncurses
, withJemalloc ? false, jemalloc
}:

stdenv.mkDerivation rec {
  pname = "ngtcp2";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "ngtcp2";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-u6orYF/VzXpcUdCitPawoet3KAhXlTQ2giR5eTQkrLY=";
  };

  outputs = [ "out" "dev" "doc" ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ libev nghttp3 quictls ] ++ lib.optional withJemalloc jemalloc;
  checkInputs = [ cunit ncurses ];

  cmakeFlags = [
    "-DENABLE_STATIC_LIB=OFF"
  ];

  doCheck = true;
  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/ngtcp2/ngtcp2";
    description = "ngtcp2 project is an effort to implement QUIC protocol which is now being discussed in IETF QUICWG for its standardization.";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ izorkin ];
  };
}
