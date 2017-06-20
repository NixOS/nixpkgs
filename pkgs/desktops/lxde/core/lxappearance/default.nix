{ stdenv, fetchurl, intltool, pkgconfig, libX11, gtk2, withGtk3 ? false, gtk3 }:

stdenv.mkDerivation rec {
  name = "lxappearance-0.6.3";

  src = fetchurl{
    url = "mirror://sourceforge/project/lxde/LXAppearance/${name}.tar.xz";
    sha256 = "0f4bjaamfxxdr9civvy55pa6vv9dx1hjs522gjbbgx7yp1cdh8kj";
  };

  nativeBuildInputs = [ pkgconfig intltool ];

  buildInputs = [ libX11 (if withGtk3 then gtk3 else gtk2) ];

  patches = [ ./lxappearance-0.6.3-xdg.system.data.dirs.patch ];

  configureFlags = stdenv.lib.optional withGtk3 "--enable-gtk3";

  meta = {
    description = "A lightweight program for configuring the theme and fonts of gtk applications";
    homepage = "http://lxde.org/";
    maintainers = [ stdenv.lib.maintainers.hinton ];
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.gpl2;
  };
}
