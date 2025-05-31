{
  lib,
  buildSddmThemePackage,
  fetchFromGitHub,
  qtgraphicaleffects,
  qtquickcontrols,
  themeConfig ? { },
}:
buildSddmThemePackage {
  pname = "sddm-chili-theme";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "MarianArlt";
    repo = "sddm-chili";
    rev = "6516d50176c3b34df29003726ef9708813d06271";
    sha256 = "036fxsa7m8ymmp3p40z671z163y6fcsa9a641lrxdrw225ssq5f3";
  };

  qtVersion = "qt5";
  sddmBuildInputs = [
    qtgraphicaleffects
    qtquickcontrols
  ];

  themeName = "Chili";
  srcThemeDir = ".";

  configPath = "theme.conf";
  configOverrides = themeConfig;

  meta = with lib; {
    license = licenses.gpl3;
    maintainers = with lib.maintainers; [ sents ];
    homepage = "https://github.com/MarianArlt/sddm-chili";
    description = "Chili login theme for SDDM";

    platforms = lib.platforms.linux;
    longDescription = ''
      Chili is hot, just like a real chili!
      Spice up the login experience for your users, your family and yourself.
      Chili reduces all the clutter and leaves you with a clean, easy to use, login interface with a modern yet classy touch.
    '';
  };
}
