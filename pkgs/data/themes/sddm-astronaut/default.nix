{
  pkgs,
  lib,
  stdenvNoCC,
  themeConfig ? null,
  embeddedTheme ? "astronaut",
}:
stdenvNoCC.mkDerivation rec {
  pname = "sddm-astronaut";
  version = "1.0-unstable-2025-01-05";

  src = pkgs.fetchFromGitHub {
    owner = "Keyitdev";
    repo = "sddm-astronaut-theme";
    rev = "11c0bf6147bbea466ce2e2b0559e9a9abdbcc7c3";
    hash = "sha256-gBSz+k/qgEaIWh1Txdgwlou/Lfrfv3ABzyxYwlrLjDk=";
  };

  dontWrapQtApps = true;

  propagatedBuildInputs = with pkgs.kdePackages; [
    qtsvg
    qtmultimedia
    qtvirtualkeyboard
  ];

  installPhase =
    let
      iniFormat = pkgs.formats.ini { };
      configFile = iniFormat.generate "" { General = themeConfig; };

      basePath = "$out/share/sddm/themes/sddm-astronaut-theme";
      sedString = "ConfigFile=Themes/";
    in
    ''
      mkdir -p ${basePath}
      cp -r $src/* ${basePath}
    ''
    + lib.optionalString (embeddedTheme != "astronaut") ''

      # Replaces astronaut.conf with embedded theme in metadata.desktop on line 9.
      # ConfigFile=Themes/astronaut.conf.
      sed -i "s|^${sedString}.*\\.conf$|${sedString}${embeddedTheme}.conf|" ${basePath}/metadata.desktop
    ''
    + lib.optionalString (themeConfig != null) ''
      chmod u+w ${basePath}/Themes/
      ln -sf ${configFile} ${basePath}/Themes/${embeddedTheme}.conf.user
    '';

  meta = {
    description = "Modern looking qt6 sddm theme";
    homepage = "https://github.com/${src.owner}/${src.repo}";
    license = lib.licenses.gpl3;

    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      danid3v
      uxodb
    ];
  };
}
