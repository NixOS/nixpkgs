{ stdenv, intltool, fetchurl, webkitgtk, pkgconfig, gtk3, glib
, file, librsvg, hicolor_icon_theme, gnome3, gdk_pixbuf
, dbus_glib, dbus_libs, telepathy_glib, telepathy_farstream
, clutter_gtk, clutter-gst, gst_all_1, cogl, gnome_online_accounts
, gcr, libsecret, folks, pulseaudio, telepathy_mission_control
, telepathy_logger, libnotify, clutter, libsoup, gnutls
, evolution_data_server
, libcanberra_gtk3, p11_kit, farstream, libtool, shared_mime_info
, bash, makeWrapper, itstool, libxml2, libxslt, icu, libgee  }:

# TODO: enable more features

stdenv.mkDerivation rec {
  name = "empathy-3.10.3";

  src = fetchurl {
    url = "mirror://gnome/sources/empathy/3.10/${name}.tar.xz";
    sha256 = "49366acdd3c3ef9a74f63eb09920803c4c9df83056acbf8a7899e7890a9fb196";
  };

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard
                            gnome3.gnome_icon_theme hicolor_icon_theme
                            gnome_online_accounts shared_mime_info
                            gnome3.gnome_icon_theme_symbolic ];
  propagatedBuildInputs = [ folks telepathy_logger evolution_data_server
                            telepathy_mission_control ];
  buildInputs = [ pkgconfig gtk3 glib webkitgtk intltool itstool
                  libxml2 libxslt icu file makeWrapper
                  telepathy_glib clutter_gtk clutter-gst cogl
                  gst_all_1.gstreamer gst_all_1.gst-plugins-base
                  gcr libsecret pulseaudio gnome3.yelp_xsl gdk_pixbuf
                  libnotify clutter libsoup gnutls libgee p11_kit
                  libcanberra_gtk3 telepathy_farstream farstream
                  gnome3.gsettings_desktop_schemas file libtool librsvg ];

  NIX_CFLAGS_COMPILE = [ "-I${dbus_glib}/include/dbus-1.0"
                         "-I${dbus_libs}/include/dbus-1.0"
                         "-I${dbus_libs}/lib/dbus-1.0/include" ];

  enableParallelBuilding = true;

  installFlags = "gsettingsschemadir=\${out}/share/empathy/glib-2.0/schemas/";

  postInstall = ''
    wrapProgram "$out/bin/empathy" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:${gtk3}/share:${gnome3.gnome_themes_standard}/:${gnome3.gnome_themes_standard}/share:${hicolor_icon_theme}/share:${gnome3.gsettings_desktop_schemas}/share:$out/share:$out/share/empathy:${telepathy_logger}/share/telepathy/logger:${folks}/share/folks:${evolution_data_server}/share/evolution-data-server"
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Empathy;
    description = "Messaging program which supports text, voice, video chat, and file transfers over many different protocols";
    maintainers = with maintainers; [ lethalman ];
    # TODO: license = [ licenses.gpl2 licenses.lgpl2 ];
    platforms = platforms.linux;
  };
}
