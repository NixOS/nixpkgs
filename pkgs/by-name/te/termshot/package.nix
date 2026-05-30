{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "termshot";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "homeport";
    repo = "termshot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YYN5ccfWkzthnwLjZAGgH8nm98Oci+KNYij8MS0/XY0=";
  };

  vendorHash = "sha256-fLbRo8f2tNN1vZGsriZ8cL4gU+wa/SfCUBrDLGXd70M=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/homeport/termshot/internal/cmd.version=${finalAttrs.version}"
  ];

  checkFlags = [ "-skip=^TestPtexec$" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
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
