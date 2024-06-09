{ stdenv
, lib
, fetchFromGitHub
, nix-update-script
, glib
, meson
, ninja
, pkg-config
, vala
, granite
, gtk3
, libgee
, libhandy
, wingpanel
}:

stdenv.mkDerivation {
  pname = "wingpanel-quick-settings";
  version = "0-unstable-2024-05-18";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "quick-settings";
    rev = "9dbd71ff9d08886b882fdd0a7e4f2f94ba21b761";
    sha256 = "sha256-b7pBaBJ/ZJ3dpkIbemHL0Dxeyn3q4X9gdk/LYsoWZPg=";
  };

  nativeBuildInputs = [
    glib # glib-compile-resources
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    glib
    granite
    gtk3
    libgee
    libhandy
    wingpanel
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Quick settings menu for Wingpanel";
    homepage = "https://github.com/elementary/quick-settings";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
