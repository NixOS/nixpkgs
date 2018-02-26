{ stdenv, intltool, fetchurl, evolution-data-server, db
, pkgconfig, gtk3, glib, libsecret
, libchamplain, clutter-gtk, geocode-glib
, bash, wrapGAppsHook, itstool, folks, libnotify, libxml2
, gnome3, librsvg, gdk_pixbuf, file, telepathy-glib, nspr, nss
, libsoup, vala, dbus-glib, automake, autoconf }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  doCheck = true;

  propagatedUserEnvPkgs = [ gnome3.gnome-themes-standard evolution-data-server ];

  # force build from vala
  preBuild = ''
   touch src/*.vala
  '';

  nativeBuildInputs = [ vala automake autoconf pkgconfig intltool itstool wrapGAppsHook file ];
  buildInputs = [ gtk3 glib evolution-data-server gnome3.gsettings-desktop-schemas libnotify
                  folks gnome3.gnome-desktop telepathy-glib libsecret dbus-glib
                  libxml2 libsoup gnome3.gnome-online-accounts nspr nss
                  gdk_pixbuf gnome3.defaultIconTheme libchamplain clutter-gtk geocode-glib db ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${gnome3.gnome-themes-standard}/share"
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
