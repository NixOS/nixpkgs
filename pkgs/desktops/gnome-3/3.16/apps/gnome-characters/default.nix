{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, intltool, gjs, gdk_pixbuf, librsvg }:

stdenv.mkDerivation rec {
  name = "gnome-characters-${gnome3.version}.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-characters/${gnome3.version}/${name}.tar.xz";
    sha256 = "1gs5k32lmjpi4scb2i7pfnbsy8pl0gb9w1aypyy83hy6ydinaqc4";
  };

  buildInputs = [
    pkgconfig gtk3 wrapGAppsHook intltool gjs gdk_pixbuf
    librsvg gnome3.defaultIconTheme
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Design/Apps/CharacterMap;
    description = "Simple utility application to find and insert unusual characters";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
