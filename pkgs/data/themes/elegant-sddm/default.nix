{
  lib,
  buildSddmThemePackage,
  fetchFromGitHub,
  qtgraphicaleffects,
  themeConfig ? { },
}:
buildSddmThemePackage {
  pname = "elegant-sddm";
  version = "unstable-2024-02-08";

  src = fetchFromGitHub {
    owner = "surajmandalcell";
    repo = "Elegant-sddm";
    rev = "3102e880f46a1b72c929d13cd0a3fb64f973952a";
    hash = "sha256-yn0fTYsdZZSOcaYlPCn8BUIWeFIKcTI1oioTWqjYunQ=";
  };

  qtVersion = "qt5";
  sddmBuildInputs = [
    qtgraphicaleffects
  ];

  themeName = "Elegant";
  srcThemeDir = "Elegant";

  configPath = "theme.conf";
  configOverrides = themeConfig;

  meta = with lib; {
    description = "Sleek and stylish SDDM theme crafted in QML";
    homepage = "https://github.com/surajmandalcell/Elegant-sddm";
    license = licenses.gpl3;

    platforms = platforms.linux;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
