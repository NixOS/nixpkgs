{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  adwaita-icon-theme,
  hicolor-icon-theme,
  gtk3,
  xcursorgen,
  librsvg,
}:

stdenvNoCC.mkDerivation rec {
  pname = "elementary-icon-theme";
  version = "8.2.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "icons";
    tag = version;
    hash = "sha256-ntv+efkyfB66HL3tWEkiOj+MFRGqhfMo1/FUO2fIqBM=";
  };

  nativeBuildInputs = [
    gtk3
    librsvg
    meson
    ninja
    xcursorgen
  ];

  propagatedBuildInputs = [
    adwaita-icon-theme
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  mesonFlags = [
    "-Dvolume_icons=false" # Tries to install some icons to /
    "-Dpalettes=false" # Don't install gimp and inkscape palette files
  ];

  postFixup = "gtk-update-icon-cache $out/share/icons/elementary";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Named, vector icons for elementary OS";
    longDescription = ''
      An original set of vector icons designed specifically for elementary OS and its desktop environment: Pantheon.
    '';
    homepage = "https://github.com/elementary/icons";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
  };
}
