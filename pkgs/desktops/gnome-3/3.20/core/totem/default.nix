{ stdenv, intltool, fetchurl, gst_all_1
, clutter_gtk, clutter-gst, python3Packages, shared_mime_info
, pkgconfig, gtk3, glib, gobjectIntrospection
, bash, wrapGAppsHook, itstool, libxml2, dbus_glib
, gnome3, librsvg, gdk_pixbuf, file, tracker, nautilus }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  doCheck = true;

  enableParallelBuilding = true;

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib.dev}/include/gio-unix-2.0";

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  buildInputs = [ pkgconfig gtk3 glib intltool itstool libxml2 gnome3.grilo
                  clutter_gtk clutter-gst gnome3.totem-pl-parser gnome3.grilo-plugins
                  gst_all_1.gstreamer gst_all_1.gst-plugins-base
                  gst_all_1.gst-plugins-good gst_all_1.gst-plugins-bad gst_all_1.gst-plugins-ugly gst_all_1.gst-libav
                  gnome3.libpeas shared_mime_info dbus_glib
                  gdk_pixbuf gnome3.defaultIconTheme librsvg gnome3.gnome_desktop
                  gnome3.gsettings_desktop_schemas wrapGAppsHook file tracker nautilus ];

  patches = [ ./x86.patch ];

  propagatedBuildInputs = [ gobjectIntrospection python3Packages.pylint python3Packages.pygobject ];

  configureFlags = [ "--with-nautilusdir=$(out)/lib/nautilus/extensions-3.0" ];

  GI_TYPELIB_PATH = "$out/lib/girepository-1.0";

  wrapPrefixVariables = [ "PYTHONPATH" ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Videos;
    description = "Movie player for the GNOME desktop based on GStreamer";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
