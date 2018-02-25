{ stdenv, fetchurl, lib, wrapGAppsHook
, pkgconfig, gnome3, gtk3, glib, intltool, libXtst, libnotify, libsoup
, telepathySupport ? false, dbus-glib ? null, telepathy-glib ? null
, libsecret ? null, gnutls ? null, libgcrypt ? null, avahi ? null
, zlib ? null, libjpeg ? null
, libXdamage ? null, libXfixes ? null, libXext ? null
, gnomeKeyringSupport ? false, libgnome-keyring3 ? null
, networkmanager ? null }:

with lib;

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  doCheck = true;

  buildInputs = [
    wrapGAppsHook
    pkgconfig gnome3.defaultIconTheme gtk3 glib intltool libXtst libnotify libsoup
  ] ++ optionals telepathySupport [ dbus-glib telepathy-glib ]
    ++ optional gnomeKeyringSupport libgnome-keyring3
    ++ filter (p: p != null) [
      libsecret gnutls libgcrypt avahi zlib libjpeg
      libXdamage libXfixes libXext networkmanager
    ];

  preFixup = ''
    export GSETTINGS_SCHEMAS_PATH="$out/share/gsettings-schemas/${name}:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/action/show/Projects/Vino;
    description = "GNOME desktop sharing server";
    maintainers = with maintainers; [ lethalman domenkozar ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
