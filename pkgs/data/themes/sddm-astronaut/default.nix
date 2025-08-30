{
  lib,
  buildSddmThemePackage,
  fetchFromGitHub,
  qt6,
  themeConfig ? { },
  flavor ? "astronaut",
}:
buildSddmThemePackage {
  pname = "sddm-astronaut";
  version = "1.0-unstable-2025-01-05";

  src = fetchFromGitHub {
    owner = "Keyitdev";
    repo = "sddm-astronaut-theme";
    rev = "11c0bf6147bbea466ce2e2b0559e9a9abdbcc7c3";
    hash = "sha256-gBSz+k/qgEaIWh1Txdgwlou/Lfrfv3ABzyxYwlrLjDk=";
  };

  sddmBuildInputs = with qt6; [
    qtmultimedia
    qtvirtualkeyboard
  ];

  themeName = "sddm-astronaut-theme";
  srcThemeDir = ".";

  configPath = "Themes/${flavor}.conf";
  configOverrides = themeConfig;

  meta = {
    description = "Modern looking qt6 sddm theme";
    homepage = "https://github.com/Keyitdev/sddm-astronaut-theme";
    license = lib.licenses.gpl3;

    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      danid3v
      uxodb
    ];
  };
}
