{ stdenv, intltool, fetchurl, libgweather, libnotify
, pkgconfig, gtk3, glib, gsound
, makeWrapper, itstool, libcanberra_gtk3, libtool
, gnome3, librsvg, gdk_pixbuf, geoclue2, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "gnome-clocks-${gnome3.version}.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-clocks/${gnome3.version}/${name}.tar.xz";
    sha256 = "1k7khghaq7y3j0r3kn9q7dwgi1875bfn4iy0sr1ls14m1p2bl10q";
  };

  doCheck = true;

  buildInputs = [ pkgconfig gtk3 glib intltool itstool libcanberra_gtk3
                  gnome3.gsettings_desktop_schemas makeWrapper
                  gdk_pixbuf gnome3.defaultIconTheme librsvg
                  gnome3.gnome_desktop gnome3.geocode_glib geoclue2
                  libgweather libnotify libtool gsound
                  wrapGAppsHook ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Clocks;
    description = "Clock application designed for GNOME 3";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
