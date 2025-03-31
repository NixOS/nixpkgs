{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "termshot";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "homeport";
    repo = "termshot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vkxOUo1RyzZBN2+wRn8yWV930HrKRJnPwpHnxza5GNE=";
  };

  vendorHash = "sha256-Wsoy0jlwMYlN8yh7xncGrxTl0qJsPXV4IdYzU7jStzw=";

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
