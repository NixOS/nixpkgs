{ stdenv, fetchurl, lib, wrapGAppsHook
, pkgconfig, gnome3, gtk3, glib, intltool, libXtst, libnotify, libsoup
, telepathySupport ? false, dbus-glib ? null, telepathy-glib ? null
, libsecret, gnutls, libgcrypt, avahi, zlib, libjpeg, libXdamage, libXfixes, libXext
, networkmanager }:

with lib;

stdenv.mkDerivation rec {
  name = "vino-${version}";
  version = "3.22.0";

  src = fetchurl {
    url = "mirror://gnome/sources/vino/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "2911c779b6a2c46e5bc8e5a0c94c2a4d5bd4a1ee7e35f2818702cb13d9d23bab";
  };

  doCheck = true;

  nativeBuildInputs = [ intltool wrapGAppsHook pkgconfig ];

  buildInputs = [
    gnome3.defaultIconTheme gtk3 glib libXtst libnotify libsoup
    libsecret gnutls libgcrypt avahi zlib libjpeg
    libXdamage libXfixes libXext networkmanager
  ] ++ optionals telepathySupport [ dbus-glib telepathy-glib ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "vino";
      attrPath = "gnome3.vino";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/Vino;
    description = "GNOME desktop sharing server";
    maintainers = with maintainers; [ lethalman domenkozar ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
