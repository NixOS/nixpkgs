{ stdenv
, fetchFromGitHub
, pantheon
, meson
, python3
, ninja
, hicolor-icon-theme
, gtk3
}:

stdenv.mkDerivation rec {
  pname = "elementary-icon-theme";
  version = "5.1.0";

  repoName = "icons";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "1yrf92ysjh1yfm42wznlw0lh9zsm5whghwzx3b3wcdkwdhkdg24z";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    gtk3
    meson
    ninja
    python3
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

  meta = with stdenv.lib; {
    description = "Named, vector icons for elementary OS";
    longDescription = ''
      An original set of vector icons designed specifically for elementary OS and its desktop environment: Pantheon.
    '';
    homepage = https://github.com/elementary/icons;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
