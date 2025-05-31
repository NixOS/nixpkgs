{
  lib,
  buildSddmThemePackage,
  fetchFromGitHub,
  qt5,
  themeConfig ? { },
}:
buildSddmThemePackage rec {
  pname = "sddm-sugar-dark";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "MarianArlt";
    repo = "sddm-sugar-dark";
    rev = "v${version}";
    hash = "sha256-C3qB9hFUeuT5+Dos2zFj5SyQegnghpoFV9wHvE9VoD8=";
  };

  qtVersion = "qt5";
  sddmBuildInputs = with qt5; [
    qtgraphicaleffects
  ];

  themeName = "Sugar Dark";
  srcThemeDir = ".";

  configPath = "theme.conf";
  configOverrides = themeConfig;

  meta = {
    description = "Dark SDDM theme from the sugar family";
    homepage = "https://github.com/MarianArlt/sddm-sugar-dark";
    license = lib.licenses.gpl3;

    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ danid3v ];
  };
}
