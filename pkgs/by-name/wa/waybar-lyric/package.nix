{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  installShellFiles,
}:
buildGoModule (finalAttrs: {
  pname = "waybar-lyric";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "Nadim147c";
    repo = "waybar-lyric";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1kUAOR7p27pLMH7zlbj+tTlIh0f8JQuWhzQVWvOyKoo=";
  };

  vendorHash = "sha256-pzHNa/55n84VSFaWmgOtwWmmDLoNE6o8mgpFCz7r8FQ=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd waybar-lyric \
      --bash <($out/bin/waybar-lyric _carapace bash) \
      --fish <($out/bin/waybar-lyric _carapace fish) \
      --zsh <($out/bin/waybar-lyric _carapace zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
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
    maintainers = with lib.maintainers; [
      Nadim147c
      vanadium5000
    ];
    platforms = lib.platforms.linux;
  };
})
