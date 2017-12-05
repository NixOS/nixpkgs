{ lib, stdenv, fetchurl, pkgconfig
, wayland
}:

stdenv.mkDerivation rec {
  name = "wayland-protocols-${version}";
  version = "1.10";

  src = fetchurl {
    url = "http://wayland.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "5719c51d7354864983171c5083e93a72ac99229e2b460c4bb10513de08839c0a";
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
