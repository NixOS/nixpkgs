{
  lib,
  stdenvNoCC,
  pkgs,
  themeConfig ? null,
}:
stdenvNoCC.mkDerivation rec {
  pname = "sddm-tokyo-night";
  version = "0-unstable-2023-06-13";

  src = pkgs.fetchFromGitHub {
    owner = "siddrs";
    repo = "tokyo-night-sddm";
    rev = "320c8e74ade1e94f640708eee0b9a75a395697c6";
    sha256 = "1gf074ypgc4r8pgljd8lydy0l5fajrl2pi2avn5ivacz4z7ma595";
  };

  dontWrapQtApps = true;

  propagatedUserEnvPkgs = with pkgs.libsForQt5.qt5; [
    qtquickcontrols2
    qtgraphicaleffects
    qtsvg
  ];

  installPhase = let
    iniFormat = pkgs.formats.ini {};
    configFile = iniFormat.generate "" {General = themeConfig;};

    basePath = "$out/share/sddm/themes/tokyo-night";
  in
    ''
      mkdir -p ${basePath}
      cp -r $src/* ${basePath}
    ''
    + lib.optionalString (themeConfig != null) ''
      ln -sf ${configFile} ${basePath}/theme.conf.user
    '';

  meta = {
    description = "Tokyo Night for SDDM";
    homepage = "https://github.com/${src.owner}/${src.repo}";
    license = lib.licenses.lgpl21;

    platforms = lib.platforms.linux;
  };
}
