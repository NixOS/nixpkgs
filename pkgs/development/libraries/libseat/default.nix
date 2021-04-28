{ fetchFromSourcehut
, lib
, meson
, ninja
, pkg-config
, stdenv
, systemd
}:

stdenv.mkDerivation rec {
  pname = "libseat";
  version = "0.5.0";

  src = fetchFromSourcehut {
    owner = "~kennylevinsen";
    repo = "seatd";
    rev = version;
    sha256 = "sha256-JwlJLHkRgSRqfQEhXbzuFTmhxfbwKVdLICPbTDbC9M0=";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];

  buildInputs = [
    systemd
  ];

  mesonFlags = [ "-Dserver=disabled" "-Dseatd=disabled" "-Dlogind=enabled"];

  meta = with lib; {
    description = "A universal seat management library";
    changelog   = "https://git.sr.ht/~kennylevinsen/seatd/refs/${version}";
    homepage    = "https://sr.ht/~kennylevinsen/seatd/";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ emantor ];
  };
}
