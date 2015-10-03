{ stdenv, fetchurl, pkgconfig, gtk3, gnome3, gdk_pixbuf
, librsvg, intltool, itstool, libxml2, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "tali-${gnome3.version}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/tali/${gnome3.version}/${name}.tar.xz";
    sha256 = "10cfgxiqg38z5ngkiznglxjgm1552mjvfw4bjhjic0yi5cvdr6dg";
  };

  buildInputs = [ pkgconfig gtk3 gnome3.defaultIconTheme gdk_pixbuf librsvg
                  libxml2 itstool intltool wrapGAppsHook ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Tali;
    description = "Sort of poker with dice and less money";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
