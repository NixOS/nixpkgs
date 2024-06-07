{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, pkg-config
, meson
, ninja
, vala
, desktop-file-utils
, gtk4
, glib
, granite7
, libgee
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "elementary-shortcut-overlay";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "shortcut-overlay";
    rev = version;
    sha256 = "sha256-YVeCO7mZmf+FEY4d8tvC76lW/HkOwQ6kw7nvmzAFEtw=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    granite7
    gtk4
    libgee
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Native OS-wide shortcut overlay to be launched by Gala";
    homepage = "https://github.com/elementary/shortcut-overlay";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.shortcut-overlay";
  };
}
