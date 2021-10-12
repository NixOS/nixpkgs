{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, meson
, python3
, ninja
, hicolor-icon-theme
, gtk3
, xorg
, librsvg
}:

stdenv.mkDerivation rec {
  pname = "elementary-icon-theme";
  version = "6.0.0";

  repoName = "icons";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "0k94zi8fzi0nf5q471fmrlz8jjkv8m6vav1spzv7ynkg2hik8d9b";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    gtk3
    librsvg
    meson
    ninja
    python3
    xorg.xcursorgen
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

  meta = with lib; {
    description = "Named, vector icons for elementary OS";
    longDescription = ''
      An original set of vector icons designed specifically for elementary OS and its desktop environment: Pantheon.
    '';
    homepage = "https://github.com/elementary/icons";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
