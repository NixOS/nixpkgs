{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "terminal-space-program";
  version = "0.38.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jasonfen";
    repo = "terminal-space-program";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G9yUzzREgu1OK44NbSs9teS+yP8dRZIV8gvATklc804=";
  };

  vendorHash = "sha256-5bhIP7It6rqOFvXRBUIP6/nGz4X+dzm3/BjVeo3nw4I=";

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
    maintainers = with lib.maintainers; [ tomasrivera ];
    mainProgram = "terminal-space-program";
  };
})
