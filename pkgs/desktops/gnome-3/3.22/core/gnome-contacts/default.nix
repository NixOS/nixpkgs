{ stdenv, intltool, fetchurl, evolution_data_server, db
, pkgconfig, gtk3, glib, libsecret
, libchamplain, clutter_gtk, geocode_glib
, bash, wrapGAppsHook, itstool, folks, libnotify, libxml2
, gnome3, librsvg, gdk_pixbuf, file, telepathy_glib, nspr, nss
, libsoup, vala_0_32, dbus_glib, automake115x, autoconf }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  doCheck = true;

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard evolution_data_server ];

  # force build from vala
  preBuild = ''
   touch src/*.vala
  '';

  buildInputs = [ pkgconfig gtk3 glib intltool itstool evolution_data_server
                  gnome3.gsettings_desktop_schemas wrapGAppsHook file libnotify
                  folks gnome3.gnome_desktop telepathy_glib libsecret dbus_glib
                  libxml2 libsoup gnome3.gnome_online_accounts nspr nss
                  gdk_pixbuf gnome3.defaultIconTheme librsvg gnome3.dconf
                  libchamplain clutter_gtk geocode_glib
                  vala_0_32 automake115x autoconf db ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix GIO_EXTRA_MODULES "${gnome3.dconf}/lib/gio/modules"
      --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share"
    )
  '';

  patches = [ ./gio_unix.patch ];

  patchFlags = "-p0";

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Contacts;
    description = "Contacts is GNOME's integrated address book";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
