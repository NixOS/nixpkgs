{ lib
, stdenv
, desktop-file-utils
, nix-update-script
, fetchFromGitHub
, flatpak
, gettext
, glib
, granite7
, gtk4
, meson
, ninja
, pkg-config
, vala
, libxml2
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "sideload";
  version = "6.3.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-2tYdcHx77XN2iu2PKXAKwOtb4TOFt3Igv17w2zIxqT4=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    flatpak
    glib
    granite7
    gtk4
    libxml2
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    homepage = "https://github.com/elementary/sideload";
    description = "Flatpak installer, designed for elementary OS";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.sideload";
  };
}
