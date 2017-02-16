{ stdenv, fetchurl, intltool, pkgconfig, libX11, gtk2 }:

stdenv.mkDerivation rec {
  name = "lxappearance-0.6.3";

  src = fetchurl{
    url = "mirror://sourceforge/project/lxde/LXAppearance/${name}.tar.xz";
    sha256 = "0f4bjaamfxxdr9civvy55pa6vv9dx1hjs522gjbbgx7yp1cdh8kj";
  };

  nativeBuildInputs = [ pkgconfig intltool ];

  buildInputs = [ libX11 gtk2 ];

  meta = {
    description = "A lightweight program for configuring the theme and fonts of gtk applications";
    homepage = "http://lxde.org/";
    maintainers = [ stdenv.lib.maintainers.hinton ];
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.gpl2;
  };
}
