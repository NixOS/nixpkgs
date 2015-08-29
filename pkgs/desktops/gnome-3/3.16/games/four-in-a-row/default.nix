{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, intltool, itstool, libcanberra_gtk3, librsvg, libxml2 }:

stdenv.mkDerivation rec {
  name = "four-in-a-row-${gnome3.version}.2";

  src = fetchurl {
    url = "mirror://gnome/sources/four-in-a-row/${gnome3.version}/${name}.tar.xz";
    sha256 = "1bm5chsvpw0jg1xh9g2n1w5i0fvxs50aqkgmrla9cpawsvzfshmz";
  };

  buildInputs = [
    pkgconfig gtk3 wrapGAppsHook intltool itstool libcanberra_gtk3 librsvg
    libxml2 gnome3.defaultIconTheme
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Four-in-a-row;
    description = "Make lines of the same color to win";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
