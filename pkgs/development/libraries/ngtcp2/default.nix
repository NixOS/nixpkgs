{ lib, stdenv, fetchFromGitHub
, autoreconfHook, pkg-config, file
, libev, nghttp3, quictls
, cunit, ncurses
, withJemalloc ? false, jemalloc
}:

stdenv.mkDerivation rec {
  pname = "ngtcp2";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "ngtcp2";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ehOIWUGSPyHhNitkkA8voVciuEsCoRWv1s3MVMmOT0c=";
  };

  outputs = [ "out" "dev" "doc" ];

  nativeBuildInputs = [ autoreconfHook pkg-config file ];
  buildInputs = [ libev nghttp3 quictls ] ++ lib.optional withJemalloc jemalloc;
  checkInputs = [ cunit ncurses ];

  preConfigure = ''
    substituteInPlace ./configure --replace /usr/bin/file ${file}/bin/file
  '';

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
