{ stdenv, intltool, fetchurl, pkgconfig, gtk3, glib, nspr, icu
, bash, wrapGAppsHook, gnome3, libwnck3, libxml2, libxslt, libtool
, webkitgtk, libsoup, glib_networking, libsecret, gnome_desktop, libnotify, p11_kit
, sqlite, gcr, avahi, nss, isocodes, itstool, file, which
, gdk_pixbuf, librsvg, gnome_common, gst_all_1, json_glib }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  # Tests need an X display
  configureFlags = [ "--disable-static --disable-tests" ];

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  nativeBuildInputs = [ pkgconfig file wrapGAppsHook ];

  buildInputs = [ gtk3 glib intltool libwnck3 libxml2 libxslt file
                  webkitgtk libsoup libsecret gnome_desktop libnotify libtool
                  sqlite isocodes nss itstool p11_kit nspr icu gnome3.yelp_tools
                  gdk_pixbuf gnome3.defaultIconTheme librsvg which gnome_common
                  gcr avahi gnome3.gsettings_desktop_schemas gnome3.dconf
                  gnome3.glib_networking gst_all_1.gstreamer gst_all_1.gst-plugins-base
                  gst_all_1.gst-plugins-good gst_all_1.gst-plugins-bad gst_all_1.gst-plugins-ugly
                  gst_all_1.gst-libav json_glib ];

  NIX_CFLAGS_COMPILE = "-I${nss.dev}/include/nss -I${glib.dev}/include/gio-unix-2.0";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Epiphany;
    description = "WebKit based web browser for GNOME";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
