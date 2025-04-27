{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "termshot";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "homeport";
    repo = "termshot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fk1Xlgf6WR6dAekv7gZXPfKTEvbnk7FT+mn8UYFbQnQ=";
  };

  vendorHash = "sha256-RuIn4JNt4c47p2uiLtmCVYyY0/K1kJpmUboXHA5vhew=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/homeport/termshot/internal/cmd.version=${finalAttrs.version}"
  ];

  checkFlags = [ "-skip=^TestPtexec$" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Creates screenshots based on terminal command output";
    homepage = "https://github.com/homeport/termshot";
    changelog = "https://github.com/homeport/termshot/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ defelo ];
    mainProgram = "termshot";
  };
})
