{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, libxml2, intltool, itstool }:

stdenv.mkDerivation rec {
  name = "hitori-${gnome3.version}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/hitori/${gnome3.version}/${name}.tar.xz";
    sha256 = "07pm3xl05jgb8x151k1j2ap57dmfvk2nkz9dmqnn5iywfigsysd1";
  };

  buildInputs = [
    pkgconfig gtk3 wrapGAppsHook intltool itstool libxml2
    gnome3.defaultIconTheme
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Hitori;
    description = "GTK+ application to generate and let you play games of Hitori";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
