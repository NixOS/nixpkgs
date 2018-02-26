{ stdenv, intltool, fetchurl, webkitgtk, pkgconfig, gtk3, glib
, file, librsvg, gnome3, gdk_pixbuf
, dbus-glib, dbus_libs, telepathy-glib, telepathy-farstream
, clutter-gtk, clutter-gst, gst_all_1, cogl, gnome-online-accounts
, gcr, libsecret, folks, libpulseaudio, telepathy-mission-control
, telepathy-logger, libnotify, clutter, libsoup, gnutls
, evolution-data-server, yelp-xsl
, libcanberra-gtk3, p11-kit, farstream, libtool, shared-mime-info
, bash, wrapGAppsHook, itstool, libxml2, libxslt, icu, libgee
, isocodes, enchant, libchamplain, geoclue2, geocode-glib, cheese, libgudev }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  propagatedUserEnvPkgs = [
    gnome-online-accounts shared-mime-info
  ];
  propagatedBuildInputs = [
    folks telepathy-logger evolution-data-server telepathy-mission-control
  ];
  nativeBuildInputs = [
    pkgconfig libtool intltool itstool file wrapGAppsHook
    libxml2 libxslt yelp-xsl
  ];
  buildInputs = [
    gtk3 glib webkitgtk icu gnome-online-accounts
    telepathy-glib clutter-gtk clutter-gst cogl
    gst_all_1.gstreamer gst_all_1.gst-plugins-base
    gcr libsecret libpulseaudio gdk_pixbuf
    libnotify clutter libsoup gnutls libgee p11-kit
    libcanberra-gtk3 telepathy-farstream farstream
    gnome3.defaultIconTheme gnome3.gsettings-desktop-schemas
    librsvg
    # Spell-checking
    enchant isocodes
    # Display maps, location awareness, geocode support
    libchamplain geoclue2 geocode-glib
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
