{ stdenv, fetchurl, pkgconfig, libX11, libXi, xkeyboard_config, libxml2
, libICE, glib, libxkbfile, isocodes }:

let
  version = "5.3";
in
stdenv.mkDerivation rec {
  name = "libxklavier-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/libxklavier/${version}/${name}.tar.xz";
    sha256 = "016lpdv35z0qsw1cprdc2k5qzkdi5waj6qmr0a2q6ljn9g2kpv7b";
  };

  # TODO: enable xmodmap support, needs xmodmap DB
  propagatedBuildInputs = [ libX11 libXi xkeyboard_config libxml2 libICE glib libxkbfile isocodes ];

  nativeBuildInputs = [ pkgconfig ];

  configureFlags = ''
    --with-xkb-base=${xkeyboard_config}/etc/X11/xkb
    --disable-xmodmap-support
  '';

  meta = {
    homepage = http://freedesktop.org/wiki/Software/LibXklavier;
  };
}
