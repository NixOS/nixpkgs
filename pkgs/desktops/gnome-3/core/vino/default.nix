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
  name = "vino-${version}";
  version = "3.22.0";

  src = fetchurl {
    url = "mirror://gnome/sources/vino/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "2911c779b6a2c46e5bc8e5a0c94c2a4d5bd4a1ee7e35f2818702cb13d9d23bab";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "vino"; attrPath = "gnome3.vino"; };
  };

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
