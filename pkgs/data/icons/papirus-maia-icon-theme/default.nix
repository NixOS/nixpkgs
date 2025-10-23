{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gtk3,
  breeze-icons,
  gnome-icon-theme,
  papirus-icon-theme,
  hicolor-icon-theme,
}:

stdenv.mkDerivation {
  pname = "papirus-maia-icon-theme";
  version = "2019-07-26";

  src = fetchFromGitHub {
    owner = "Ste74";
    repo = "papirus-maia-icon-theme";
    rev = "90d47c817cc0edeed8b5a90335e669948ff4a116";
    sha256 = "0d6lvdg5nw5wfaq8lxszcws174vg12ywkrqzn6czimhmhp48jf5p";
  };

  nativeBuildInputs = [
    cmake
    gtk3
  ];

  propagatedBuildInputs = [
    breeze-icons
    gnome-icon-theme
    papirus-icon-theme
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  dontWrapQtApps = true;

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace /usr "$out"
  '';

  postInstall = ''
    for theme in $out/share/icons/*; do
      gtk-update-icon-cache $theme
    done
  '';

  meta = {
    description = "Manjaro variation of Papirus icon theme";
    homepage = "https://github.com/Ste74/papirus-maia-icon-theme";
    license = lib.licenses.lgpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ romildo ];
  };
}
