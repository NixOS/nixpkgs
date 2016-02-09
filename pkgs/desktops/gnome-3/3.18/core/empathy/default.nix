{ stdenv, intltool, fetchurl, webkitgtk, pkgconfig, gtk3, glib
, file, librsvg, gnome3, gdk_pixbuf
, dbus_glib, dbus_libs, telepathy_glib, telepathy_farstream
, clutter_gtk, clutter-gst, gst_all_1, cogl, gnome_online_accounts
, gcr, libsecret, folks, libpulseaudio, telepathy_mission_control
, telepathy_logger, libnotify, clutter, libsoup, gnutls
, evolution_data_server
, libcanberra_gtk3, p11_kit, farstream, libtool, shared_mime_info
, bash, makeWrapper, itstool, libxml2, libxslt, icu, libgee  }:

# TODO: enable more features

let
  majorVersion = "3.12";
in
stdenv.mkDerivation rec {
  name = "empathy-${majorVersion}.8";

  src = fetchurl {
    url = "mirror://gnome/sources/empathy/${majorVersion}/${name}.tar.xz";
    sha256 = "10z6ksia6yx7vg0wsdbk4w6vjgfg3cg3n04jf9bj2vr7kr5zvs7w";
  };

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard
                            gnome_online_accounts shared_mime_info ];
  propagatedBuildInputs = [ folks telepathy_logger evolution_data_server
                            telepathy_mission_control ];
  buildInputs = [ pkgconfig gtk3 glib webkitgtk intltool itstool
                  libxml2 libxslt icu file makeWrapper
                  telepathy_glib clutter_gtk clutter-gst cogl
                  gst_all_1.gstreamer gst_all_1.gst-plugins-base
                  gcr libsecret libpulseaudio gnome3.yelp_xsl gdk_pixbuf
                  libnotify clutter libsoup gnutls libgee p11_kit
                  libcanberra_gtk3 telepathy_farstream farstream
                  gnome3.defaultIconTheme gnome3.gsettings_desktop_schemas
                  file libtool librsvg ];

  NIX_CFLAGS_COMPILE = [ "-I${dbus_glib}/include/dbus-1.0"
                         "-I${dbus_libs}/include/dbus-1.0"
                         "-I${dbus_libs}/lib/dbus-1.0/include" ];

  preFixup = ''
    for f in $out/bin/* $out/libexec/*; do
      wrapProgram $f \
        --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
        --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:${gnome3.gnome_themes_standard}/share:$out/share:$GSETTINGS_SCHEMAS_PATH"
    done
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Empathy;
    description = "Messaging program which supports text, voice, video chat, and file transfers over many different protocols";
    maintainers = gnome3.maintainers;
    # TODO: license = [ licenses.gpl2 licenses.lgpl2 ];
    platforms = platforms.linux;
  };
}
