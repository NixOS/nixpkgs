{ lib, stdenv, fetchurl, pkgconfig
, wayland
}:

stdenv.mkDerivation rec {
  name = "wayland-protocols-${version}";
  version = "1.14";

  src = fetchurl {
    url = "http://wayland.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "1xknjcfhqvdi1s4iq4kk1q61fg2rar3g8q4vlqarpd324imqjj4n";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ wayland ];

  meta = {
    description = "Wayland protocol extensions";
    homepage    = http://wayland.freedesktop.org/;
    license     = lib.licenses.mit;
    platforms   = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ];
  };

  passthru.version = version;
}
