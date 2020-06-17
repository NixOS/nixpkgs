{ stdenv
, fetchFromGitHub
, pantheon
, meson
, python3
, ninja
, pkgconfig
, vala
, glib
, libgee
, dbus
, glib-networking
, wrapGAppsHook
}:

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
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    dbus
    meson
    ninja
    pkgconfig
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    glib-networking
    libgee
  ];

  PKG_CONFIG_DBUS_1_SESSION_BUS_SERVICES_DIR = "${placeholder "out"}/share/dbus-1/services";

  meta = with stdenv.lib; {
    description = "A desktop-wide extension service used by elementary OS";
    homepage = "https://github.com/elementary/contractor";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
