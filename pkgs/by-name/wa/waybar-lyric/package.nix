{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  installShellFiles,
}:
buildGoModule (finalAttrs: {
  pname = "waybar-lyric";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "Nadim147c";
    repo = "waybar-lyric";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UHz4eKHfwrvNMil5DYoSBFqIvhENYd075w86xRoYNCU=";
  };

  vendorHash = "sha256-49bK9SDNSsTYT4Mmkzn6kLs7CRozxCKEN/jr6QH0JmY=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  versionCheckKeepEnvironment = [ "XDG_CACHE_HOME" ];
  preInstallCheck = ''
    # ERROR Failed to find cache directory
    export XDG_CACHE_HOME=$(mktemp -d)
  '';

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd waybar-lyric \
            --bash <($out/bin/waybar-lyric _carapace bash) \
            --fish <($out/bin/waybar-lyric _carapace fish) \
            --zsh <($out/bin/waybar-lyric _carapace zsh)
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
