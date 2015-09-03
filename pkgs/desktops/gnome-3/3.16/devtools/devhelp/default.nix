{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, webkitgtk, intltool }:

stdenv.mkDerivation rec {
  name = "devhelp-${gnome3.version}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/devhelp/${gnome3.version}/${name}.tar.xz";
    sha256 = "0i8kyh86hzwxs8dm047ivghl2b92vigdxa3x4pk4ha0whpk38g37";
  };

  buildInputs = [
    pkgconfig gtk3 wrapGAppsHook webkitgtk intltool gnome3.defaultIconTheme
  ];

  meta = with stdenv.lib; {
    homepage = https://live.gnome.org/devhelp;
    description = "API documentation browser for GNOME";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
