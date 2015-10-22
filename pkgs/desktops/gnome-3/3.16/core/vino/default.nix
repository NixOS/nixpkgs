{ stdenv, fetchurl, lib, makeWrapper
, pkgconfig, gnome3, gtk3, glib, intltool, libXtst, libnotify, libsoup
, telepathySupport ? false, dbus_glib ? null, telepathy_glib ? null
, libsecret ? null, gnutls ? null, libgcrypt ? null, avahi ? null
, zlib ? null, libjpeg ? null
, libXdamage ? null, libXfixes ? null, libXext ? null
, gnomeKeyringSupport ? false, libgnome_keyring3 ? null
, networkmanager ? null }:

with lib;

stdenv.mkDerivation rec {
  name = "vino-${versionMajor}.${versionMinor}";
  versionMajor = gnome3.version;
  versionMinor = "0";

  src = fetchurl {
    url = "mirror://gnome/sources/vino/${versionMajor}/${name}.tar.xz";
    sha256 = "1icdc2y78xfg7czfiz05y9vsxkzzgrc0dpsrcxb41bg0sh9kd3b0";
  };

  doCheck = true;

  buildInputs = [
    makeWrapper
    pkgconfig gnome3.defaultIconTheme gtk3 glib intltool libXtst libnotify libsoup
  ] ++ optionals telepathySupport [ dbus_glib telepathy_glib ]
    ++ optional gnomeKeyringSupport libgnome_keyring3
    ++ filter (p: p != null) [
      libsecret gnutls libgcrypt avahi zlib libjpeg
      libXdamage libXfixes libXext networkmanager
    ];

  preFixup = ''
    wrapProgram "$out/libexec/vino-server" \
      --prefix XDG_DATA_DIRS : "$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/action/show/Projects/Vino;
    description = "GNOME desktop sharing server";
    maintainers = with maintainers; [ lethalman iElectric ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
