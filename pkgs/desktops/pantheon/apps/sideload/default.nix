{ lib
, stdenv
, desktop-file-utils
, nix-update-script
, elementary-icon-theme
, fetchFromGitHub
, flatpak
, gettext
, glib
, granite
, gtk3
, libgee
, libhandy
, meson
, ninja
, pkg-config
, python3
, vala
, libxml2
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "sideload";
  version = "6.0.2";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0abpcawmmv5mgzk2i5n9rlairmjr2v9rg9b8c9g7xa085s496bi9";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    elementary-icon-theme
    flatpak
    glib
    granite
    gtk3
    libgee
    libhandy
    libxml2
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
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
