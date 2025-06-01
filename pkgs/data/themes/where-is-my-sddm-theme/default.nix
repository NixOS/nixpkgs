{
  lib,
  buildSddmThemePackage,
  fetchFromGitHub,
  qt5,
  qt6,
  flavor ? "default",
  themeConfig ? { },
}:
let
  base = rec {
    pname = "where-is-my-sddm-theme";
    version = "1.12.0";

    src = fetchFromGitHub {
      owner = "stepanzubkov";
      repo = "where-is-my-sddm-theme";
      tag = "v${version}";
      hash = "sha256-+R0PX84SL2qH8rZMfk3tqkhGWPR6DpY1LgX9bifNYCg=";
    };

    themeName = "Where is my SDDM theme?";

    configPath = if flavor == "default" then "theme.conf" else "example_configs/${flavor}.conf";

    configOverrides = themeConfig;

    meta = {
      description = "Most minimalistic SDDM theme among all themes";
      homepage = "https://github.com/stepanzubkov/where-is-my-sddm-theme";
      license = lib.licenses.mit;

      platforms = lib.platforms.linux;
      maintainers = with lib.maintainers; [ name-snrl ];
    };
  };
in
{
  qt6 = buildSddmThemePackage (
    base
    // {
      sddmBuildInputs = with qt6; [
        qt5compat
        qtsvg
      ];

      srcThemeDir = "where_is_my_sddm_theme";
    }
  );

  qt5 = buildSddmThemePackage (
    base
    // {
      qtVersion = "qt5";
      sddmBuildInputs = with qt5; [
        qtgraphicaleffects
      ];

      srcThemeDir = "where_is_my_sddm_theme_qt5";
    }
  );
}
