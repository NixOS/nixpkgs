{ lib, stdenv, fetchurl, pkgconfig
, wayland
}:

stdenv.mkDerivation rec {
  name = "wayland-protocols-${version}";
  version = "1.7";

  src = fetchurl {
    url = "http://wayland.freedesktop.org/releases/${name}.tar.xz";
    sha256 = "07qw166s6bm81zfnhf4lmww6wj0il960fm3vp7n1z3rign9jlpv3";
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
