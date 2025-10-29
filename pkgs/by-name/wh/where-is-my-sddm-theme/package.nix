{
  lib,
  formats,
  stdenvNoCC,
  fetchFromGitHub,
  qt6,
  libsForQt5,
  variants ? [ "qt6" ],
  /*
    An example of how you can override the background on the NixOS logo

      environment.systemPackages = [
        (pkgs.where-is-my-sddm-theme.override {
          themeConfig.General = {
            background = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            backgroundMode = "none";
          };
        })
      ];
  */
  themeConfig ? null,
}:

let
  user-cfg = (formats.ini { }).generate "theme.conf.user" themeConfig;
  validVariants = [
    "qt5"
    "qt6"
  ];
in

lib.checkListOfEnum "where-is-my-sddm-theme: variant" validVariants variants

  stdenvNoCC.mkDerivation
  (finalAttrs: {
    pname = "where-is-my-sddm-theme";
    version = "1.12.0";

    src = fetchFromGitHub {
      owner = "stepanzubkov";
      repo = "where-is-my-sddm-theme";
      tag = "v${finalAttrs.version}";
      hash = "sha256-+R0PX84SL2qH8rZMfk3tqkhGWPR6DpY1LgX9bifNYCg=";
    };

    propagatedUserEnvPkgs =
      [ ]
      ++ lib.optionals (lib.elem "qt5" variants) [ libsForQt5.qtgraphicaleffects ]
      ++ lib.optionals (lib.elem "qt6" variants) [
        qt6.qt5compat
        qt6.qtsvg
      ];

    installPhase = ''
      mkdir -p $out/share/sddm/themes/
    ''
    + lib.optionalString (lib.elem "qt6" variants) (
      ''
        cp -r where_is_my_sddm_theme/ $out/share/sddm/themes/
      ''
      + lib.optionalString (lib.isAttrs themeConfig) ''
        ln -sf ${user-cfg} $out/share/sddm/themes/where_is_my_sddm_theme/theme.conf.user
      ''
    )
    + lib.optionalString (lib.elem "qt5" variants) (
      ''
        cp -r where_is_my_sddm_theme_qt5/ $out/share/sddm/themes/
      ''
      + lib.optionalString (lib.isAttrs themeConfig) ''
        ln -sf ${user-cfg} $out/share/sddm/themes/where_is_my_sddm_theme_qt5/theme.conf.user
      ''
    );

    meta = {
      description = "Most minimalistic SDDM theme among all themes";
      homepage = "https://github.com/stepanzubkov/where-is-my-sddm-theme";
      license = lib.licenses.mit;
      platforms = lib.platforms.linux;
      maintainers = with lib.maintainers; [ name-snrl ];
    };
  })
