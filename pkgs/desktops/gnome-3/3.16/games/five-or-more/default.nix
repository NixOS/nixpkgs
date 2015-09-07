{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, librsvg, intltool, itstool, libxml2 }:

stdenv.mkDerivation rec {
  name = "five-or-more-${gnome3.version}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/five-or-more/${gnome3.version}/${name}.tar.xz";
    sha256 = "018723w2q0fijvxs1kafrxg39f6ank6x51nfbf3mhn9q7jz9k2g3";
  };

  buildInputs = [
    pkgconfig gtk3 wrapGAppsHook librsvg intltool itstool libxml2
    gnome3.defaultIconTheme
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Five_or_more;
    description = "Remove colored balls from the board by forming lines";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
