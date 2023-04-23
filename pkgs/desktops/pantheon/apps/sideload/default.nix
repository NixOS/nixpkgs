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
, python3
, vala
, libxml2
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "sideload";
  version = "6.2.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-AIfQDkodxc3zKi9oYBWIkOw1UgW+nXufNXbpM1Jxjtg=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    meson
    ninja
    pkg-config
    python3
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

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

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
