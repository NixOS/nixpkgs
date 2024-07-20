{ pkgs, lib, stdenvNoCC, themeConfig ? null }:

stdenvNoCC.mkDerivation rec {
  pname = "sddm-sugar-dark";
  version = "1.2";

  src = pkgs.fetchFromGitHub {
    owner = "MarianArlt";
    repo = "sddm-sugar-dark";
    rev = "v${version}";
    hash = "sha256-C3qB9hFUeuT5+Dos2zFj5SyQegnghpoFV9wHvE9VoD8=";
  };

  dontWrapQtApps = true;

  buildInputs = with pkgs.libsForQt5.qt5; [ qtgraphicaleffects ];

  installPhase =
    let
      iniFormat = pkgs.formats.ini { };
      configFile = iniFormat.generate "" { General = themeConfig; };

      basePath = "$out/share/sddm/themes/sugar-dark";
    in
    ''
      mkdir -p ${basePath}
      cp -r $src/* ${basePath}
    '' + lib.optionalString (themeConfig != null) ''
      ln -sf ${configFile} ${basePath}/theme.conf.user
    '';

  meta = {
    description = "Dark SDDM theme from the sugar family";
    homepage = "https://github.com/${src.owner}/${pname}";
    license = lib.licenses.gpl3;

    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ danid3v ];
  };
}
