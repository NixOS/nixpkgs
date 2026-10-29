{
  lib,
  buildSddmThemePackage,
  fetchFromGitHub,
  qt6,
  flavor ? "default",
  /*
    An example of how you can override the background on the NixOS logo

      services.displayManager.sddm.themePackage = pkgs.where-is-my-sddm-theme.withConfig {
        background = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        backgroundMode = "none";
      };
  */

  # deprecated in favor of `.withConfig`
  themeConfig ? null,
  variants ? null,
}:
buildSddmThemePackage (finalAttrs: {
  pname = "where-is-my-sddm-theme";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "stepanzubkov";
    repo = "where-is-my-sddm-theme";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+R0PX84SL2qH8rZMfk3tqkhGWPR6DpY1LgX9bifNYCg=";
  };

  sddmBuildInputs = with qt6; [
    qt5compat
    qtsvg
  ];

  srcThemeDir =
    lib.warnIf (variants != null)
      "where-is-my-sddm-theme: `variants` is deprecated and ignored, only the Qt 6 variant is packaged"
      "where_is_my_sddm_theme";

  configPath = if flavor == "default" then "theme.conf" else "example_configs/${flavor}.conf";
  configOverrides =
    lib.warnIf (themeConfig != null)
      "where-is-my-sddm-theme: `themeConfig` is deprecated, use `where-is-my-sddm-theme.withConfig { ... }` instead"
      (themeConfig.General or { });

  meta = {
    description = "Most minimalistic SDDM theme among all themes";
    homepage = "https://github.com/stepanzubkov/where-is-my-sddm-theme";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ name-snrl ];
  };
})
