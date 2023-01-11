{ lib
, stdenvNoCC
, fetchFromGitHub
, nix-update-script
, meson
, python3
, ninja
, hicolor-icon-theme
, gtk3
, xcursorgen
, librsvg
}:

stdenvNoCC.mkDerivation rec {
  pname = "elementary-icon-theme";
  version = "7.1.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "icons";
    rev = version;
    sha256 = "sha256-SMeVu4RbXodbxtVkQE2tvv6LaVWzrq7UBlwmi30ns2Q=";
  };

  nativeBuildInputs = [
    gtk3
    librsvg
    meson
    ninja
    python3
    xcursorgen
  ];

  propagatedBuildInputs = [
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  mesonFlags = [
    "-Dvolume_icons=false" # Tries to install some icons to /
    "-Dpalettes=false" # Don't install gimp and inkscape palette files
  ];

  postPatch = ''
    chmod +x meson/symlink.py
    patchShebangs meson/symlink.py
  '';

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
    maintainers = teams.pantheon.members;
  };
}
