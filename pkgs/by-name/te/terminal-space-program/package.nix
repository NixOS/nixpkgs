{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "terminal-space-program";
  version = "0.70.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jasonfen";
    repo = "terminal-space-program";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j0GBzW6Yz7e2I7LPdjj5c56vlF6FCQ1sIqQ3lEZw2xg=";
  };

  vendorHash = "sha256-DtzGzLe5HMasMZdfO3h1VTBKGFuANyQExY/2mireTEE=";

  ldflags = [
    "-X github.com/jasonfen/terminal-space-program/internal/version.Version=${finalAttrs.version}"
  ];

  env.CGO_ENABLED = 0;

  __darwinAllowLocalNetworking = true; # the server/multiplayer tests need local networking

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal-native orbital-mechanics rocket simulator";
    homepage = "https://terminalspaceprogram.com";
    changelog = "https://github.com/jasonfen/terminal-space-program/blob/main/docs/version-history.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      tomasrivera
      jasonfen
    ];
    mainProgram = "terminal-space-program";
  };
})
