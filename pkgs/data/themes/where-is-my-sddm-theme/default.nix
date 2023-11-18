{ lib
, formats
, stdenvNoCC
, fetchFromGitHub
, qtgraphicaleffects
  /* An example of how you can override the background on the NixOS logo
  *
  *  environment.systemPackages = [
  *    (pkgs.where-is-my-sddm-theme.override {
  *      themeConfig.General = {
  *        background = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
  *        backgroundMode = "none";
  *      };
  *    })
  *  ];
  */
, themeConfig ? null
}:

let
  user-cfg = (formats.ini { }).generate "theme.conf.user" themeConfig;
in

stdenvNoCC.mkDerivation rec {
  pname = "where-is-my-sddm-theme";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "stepanzubkov";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-T6b+rxjlxZCQ/KDaxBM8ZryA3n6a+3jo+J2nETBYslM=";
  };

  propagatedUserEnvPkgs = [ qtgraphicaleffects ];

  installPhase = ''
    mkdir -p $out/share/sddm/themes/
    cp -r where_is_my_sddm_theme/ $out/share/sddm/themes/
  '' + lib.optionalString (lib.isAttrs themeConfig) ''
    ln -sf ${user-cfg} $out/share/sddm/themes/where_is_my_sddm_theme/theme.conf.user
  '';

  meta = with lib; {
    description = "The most minimalistic SDDM theme among all themes";
    homepage = "https://github.com/stepanzubkov/where-is-my-sddm-theme";
    license = licenses.mit;
    maintainers = with maintainers; [ name-snrl ];
  };
}
