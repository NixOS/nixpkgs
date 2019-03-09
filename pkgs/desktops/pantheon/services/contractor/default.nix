{ stdenv, fetchFromGitHub, pantheon, meson, python3, ninja, pkgconfig, vala, glib, libgee, dbus, glib-networking, gobject-introspection }:

stdenv.mkDerivation rec {
  pname = "contractor";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1jzqv7pglhhyrkj1pfk1l624zn1822wyl5dp6gvwn4sk3iqxwwhl";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
    };
  };

  nativeBuildInputs = [
    dbus
    gobject-introspection
    meson
    ninja
    pkgconfig
    python3
    vala
  ];

  buildInputs = [
    glib
    glib-networking
    libgee
  ];

  PKG_CONFIG_DBUS_1_SESSION_BUS_SERVICES_DIR = "share/dbus-1/services";

  meta = with stdenv.lib; {
    description = "A desktop-wide extension service used by elementary OS";
    homepage = https://github.com/elementarycontractor;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
