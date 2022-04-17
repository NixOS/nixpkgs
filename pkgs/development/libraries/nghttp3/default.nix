{ lib, stdenv, fetchFromGitHub
, autoreconfHook, pkg-config
, cunit, file, ncurses
}:

stdenv.mkDerivation rec {
  pname = "nghttp3";
  version = "unstable-2022-04-10";

  src = fetchFromGitHub {
    owner = "ngtcp2";
    repo = pname;
    rev = "1e4bef2cc45b1fd3971ca3606d08a1e1d1567b1a";
    sha256 = "sha256-DHNxtu4X0S8l1ADwRJC3yQ+Z1ja3FT0Zb/boRh6PvYw=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config file ];
  checkInputs = [ cunit ncurses ];

  preConfigure = ''
    substituteInPlace ./configure --replace /usr/bin/file ${file}/bin/file
  '';

  outputs = [ "out" "dev" ];

  doCheck = true;
  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/ngtcp2/nghttp3";
    description = "nghttp3 is an implementation of HTTP/3 mapping over QUIC and QPACK in C.";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ izorkin ];
  };
}
