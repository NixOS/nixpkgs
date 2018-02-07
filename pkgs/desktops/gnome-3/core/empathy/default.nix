{ stdenv, intltool, fetchurl, webkitgtk, pkgconfig, gtk3, glib
, file, librsvg, gnome3, gdk_pixbuf
, dbus_glib, dbus_libs, telepathy_glib, telepathy_farstream
, clutter_gtk, clutter-gst, gst_all_1, cogl, gnome_online_accounts
, gcr, libsecret, folks, libpulseaudio, telepathy_mission_control
, telepathy_logger, libnotify, clutter, libsoup, gnutls
, evolution_data_server, yelp_xsl
, libcanberra_gtk3, p11_kit, farstream, libtool, shared_mime_info
, bash, wrapGAppsHook, itstool, libxml2, libxslt, icu, libgee
, isocodes, enchant, libchamplain, geoclue2, geocode_glib, cheese, libgudev }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  propagatedUserEnvPkgs = [
    gnome_online_accounts shared_mime_info
  ];
  propagatedBuildInputs = [
    folks telepathy_logger evolution_data_server telepathy_mission_control
  ];
  nativeBuildInputs = [
    pkgconfig libtool intltool itstool file wrapGAppsHook
    libxml2 libxslt yelp_xsl
  ];
  buildInputs = [
    gtk3 glib webkitgtk icu gnome_online_accounts
    telepathy_glib clutter_gtk clutter-gst cogl
    gst_all_1.gstreamer gst_all_1.gst-plugins-base
    gcr libsecret libpulseaudio gdk_pixbuf
    libnotify clutter libsoup gnutls libgee p11_kit
    libcanberra_gtk3 telepathy_farstream farstream
    gnome3.defaultIconTheme gnome3.gsettings_desktop_schemas
    librsvg
    # Spell-checking
    enchant isocodes
    # Display maps, location awareness, geocode support
    libchamplain geoclue2 geocode_glib
    # Cheese webcam support, camera monitoring
    cheese libgudev
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Empathy;
    description = "Messaging program which supports text, voice, video chat, and file transfers over many different protocols";
    maintainers = gnome3.maintainers;
    license = [ licenses.gpl2 ];
    platforms = platforms.linux;
  };
}
