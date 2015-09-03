{ stdenv, fetchurl, intltool, pkgconfig, gnome3, gtk3
, gobjectIntrospection, gdk_pixbuf, librsvg
, geoclue2, wrapGAppsHook, folks, libchamplain, gfbgraph, file, libsoup }:

stdenv.mkDerivation rec {
  name = "gnome-maps-${gnome3.version}.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-maps/${gnome3.version}/${name}.tar.xz";
    sha256 = "15kwy2fy9v4zzjaqcifv4jaqcx1227bcdxgd6916ghrdzgj93mx7";
  };

  doCheck = true;

  buildInputs = [ pkgconfig intltool gobjectIntrospection wrapGAppsHook
                  gtk3 geoclue2 gnome3.gjs gnome3.libgee folks gfbgraph
                  gnome3.geocode_glib libchamplain file libsoup
                  gdk_pixbuf librsvg
                  gnome3.gnome_online_accounts gnome3.defaultIconTheme ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Maps;
    description = "A map application for GNOME 3";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
