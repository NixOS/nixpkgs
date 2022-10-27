{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, python3
, ninja
, pkg-config
, vala
, glib
, libgee
, dbus
, glib-networking
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "contractor";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1sqww7zlzl086pjww3d21ah1g78lfrc9aagrqhmsnnbji9gwb8ab";
  };

  nativeBuildInputs = [
    dbus
    meson
    ninja
    pkg-config
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

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  meta = with lib; {
    description = "A desktop-wide extension service used by elementary OS";
    homepage = "https://github.com/elementary/contractor";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "contractor";
  };
}
