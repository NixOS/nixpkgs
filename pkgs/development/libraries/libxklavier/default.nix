{ stdenv, fetchurl, pkgconfig, libX11, libXi, xkeyboard_config, libxml2
, libICE, glib, libxkbfile, isocodes }:

stdenv.mkDerivation rec {
  name = "libxklavier-5.0";

  src = fetchurl {
    url = "mirror://sourceforge/gswitchit/${name}.tar.bz2";
    sha256 = "1c2dxinjfpq1lzxi0z46r0j80crbmwb0lkvnh6987cjjlwblpnfz";
  };

  # TODO: enable xmodmap support, needs xmodmap DB
  propagatedBuildInputs = [ libX11 libXi xkeyboard_config libxml2 libICE glib libxkbfile isocodes ];

  buildNativeInputs = [ pkgconfig ];

  configureFlags = ''
    --with-xkb-base=${xkeyboard_config}/etc/X11/xkb
    --disable-xmodmap-support
  '';

  meta = {
    homepage = http://freedesktop.org/wiki/Software/LibXklavier;
  };
}
