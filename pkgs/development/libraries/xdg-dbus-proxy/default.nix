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
  ];

  buildInputs = [
    glib
  ];

  nativeCheckInputs = [
    dbus
  ];

  # dbus[2345]: Failed to start message bus: Failed to open "/etc/dbus-1/session.conf": No such file or directory
  doCheck = false;

  meta = {
    description = "DBus proxy for Flatpak and others";
    homepage = "https://github.com/flatpak/xdg-dbus-proxy";
    license = lib.licenses.lgpl21Plus;
    mainProgram = "xdg-dbus-proxy";
    maintainers = with lib.maintainers; [ jtojnar ];
    platforms = lib.platforms.linux;
  };
})
