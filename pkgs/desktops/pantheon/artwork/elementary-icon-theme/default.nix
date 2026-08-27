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
  version = "9.0.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "icons";
    tag = version;
    hash = "sha256-WrZxhr7ybIx9CK5zG5Fq6udPt+0HRQIPSwxkCF2tPps=";
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

  postPatch = ''
    # Upstream removed the non-fd.o office-calendar icons but left these
    # alias symlinks dangling (elementary/icons#1435).
    rm -f apps/16/calendar.svg \
      mimes/symbolic/text-calendar-symbolic.svg \
      mimes/symbolic/vcalendar-symbolic.svg
  '';

  postFixup = "gtk-update-icon-cache $out/share/icons/elementary";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Named, vector icons for elementary OS";
    longDescription = ''
      An original set of vector icons designed specifically for elementary OS and its desktop environment: Pantheon.
    '';
    homepage = "https://github.com/elementary/icons";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.pantheon ];
  };
}
