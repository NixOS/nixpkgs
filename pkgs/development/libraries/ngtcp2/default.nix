{ lib, stdenv, fetchFromGitHub
, autoreconfHook, pkg-config
, cunit, file, ncurses
, libev, nghttp3, quictls
, withJemalloc ? false, jemalloc
}:

stdenv.mkDerivation rec {
  pname = "ngtcp2";
  version = "unstable-2022-04-11";

  src = fetchFromGitHub {
    owner = "ngtcp2";
    repo = pname;
    rev = "825899c051ea2a1f06a0c4617f41782f37009a18";
    sha256 = "sha256-VoSy0tyIXWNTmcVdsaiM9ijXLq41AOaPBajvsEIrfjo=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config file ];
  buildInputs = [ libev nghttp3 quictls ] ++ lib.optional withJemalloc jemalloc;
  checkInputs = [ cunit ncurses ];

  preConfigure = ''
    substituteInPlace ./configure --replace /usr/bin/file ${file}/bin/file
  '';

  outputs = [ "out" "dev" ];

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
