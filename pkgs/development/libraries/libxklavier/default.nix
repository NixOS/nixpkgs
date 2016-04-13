{ stdenv, fetchurl, pkgconfig, xkeyboard_config, libxml2, xorg
, glib, isocodes, gobjectIntrospection }:

let
  version = "5.3";
in
stdenv.mkDerivation rec {
  name = "libxklavier-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/libxklavier/${version}/${name}.tar.xz";
    sha256 = "016lpdv35z0qsw1cprdc2k5qzkdi5waj6qmr0a2q6ljn9g2kpv7b";
  };

  outputs = [ "dev" "out" "docdev" ];

  # TODO: enable xmodmap support, needs xmodmap DB
  propagatedBuildInputs = with xorg; [ libX11 libXi xkeyboard_config libxml2 libICE glib libxkbfile isocodes ];

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ gobjectIntrospection ];

  configureFlags = [
    "--with-xkb-base=${xkeyboard_config}/etc/X11/xkb"
    "--with-xkb-bin-base=${xorg.xkbcomp}/bin"
    "--disable-xmodmap-support"
  ];

  meta = with stdenv.lib; {
    description = "Library providing high-level API for X Keyboard Extension known as XKB";
    homepage = http://freedesktop.org/wiki/Software/LibXklavier;
    license = licenses.lgpl2Plus;
  };
}

