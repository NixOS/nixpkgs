<<<<<<< HEAD
{ dbus
, docbook-xsl-nons
, docbook_xml_dtd_43
, fetchurl
, glib
, lib
, libxslt
, meson
, ninja
, pkg-config
, stdenv
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-dbus-proxy";
  version = "0.1.5";

  src = fetchurl {
    url = "https://github.com/flatpak/xdg-dbus-proxy/releases/download/${finalAttrs.version}/xdg-dbus-proxy-${finalAttrs.version}.tar.xz";
    hash = "sha256-Bh3Pr4oGUOX9nVQy3+iL2nSeoNB53BNjBL/s+84GYfs=";
  };

  nativeBuildInputs = [
    docbook-xsl-nons
    docbook_xml_dtd_43
    libxslt
    meson
    ninja
    pkg-config
=======
{ stdenv
, lib
, fetchurl
, meson
, ninja
, pkg-config
, libxslt
, docbook-xsl-nons
, docbook_xml_dtd_43
, dbus
, glib
}:

stdenv.mkDerivation rec {
  pname = "xdg-dbus-proxy";
  version = "0.1.4";

  src = fetchurl {
    url = "https://github.com/flatpak/xdg-dbus-proxy/releases/download/${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-HsDqtT0eSZZtciNSvP1RrEAtzlGQuu3HSahUHnYWcKs=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    libxslt
    docbook-xsl-nons
    docbook_xml_dtd_43
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildInputs = [
    glib
  ];

  nativeCheckInputs = [
    dbus
  ];

  # dbus[2345]: Failed to start message bus: Failed to open "/etc/dbus-1/session.conf": No such file or directory
  doCheck = false;

<<<<<<< HEAD
  meta = {
    description = "DBus proxy for Flatpak and others";
    homepage = "https://github.com/flatpak/xdg-dbus-proxy";
    license = lib.licenses.lgpl21Plus;
    mainProgram = "xdg-dbus-proxy";
    maintainers = with lib.maintainers; [ jtojnar ];
    platforms = lib.platforms.linux;
  };
})
=======
  meta = with lib; {
    description = "DBus proxy for Flatpak and others";
    homepage = "https://github.com/flatpak/xdg-dbus-proxy";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
