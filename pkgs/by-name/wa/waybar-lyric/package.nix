{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "waybar-lyric";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "Nadim147c";
    repo = "waybar-lyric";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1n00yxeDlxn/BzDF4cc+JkJZMmEtZftqey3Hwg6aAKI=";
  };

  vendorHash = "sha256-DBtSC+ePl6dvHqB10FyeojnYoT3mmsWAnbs/lZLibl8=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  versionCheckKeepEnvironment = [ "XDG_CACHE_HOME" ];
  preInstallCheck = ''
    # ERROR Failed to find cache directory
    export XDG_CACHE_HOME=$(mktemp -d)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Waybar module for displaying song lyrics";
    homepage = "https://github.com/Nadim147c/waybar-lyric";
    license = lib.licenses.agpl3Only;
    mainProgram = "waybar-lyric";
    maintainers = with lib.maintainers; [ vanadium5000 ];
    platforms = lib.platforms.linux;
  };
})
