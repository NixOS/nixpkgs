{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "vulnx";
  version = "2.0.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "vulnx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oIoLInhErN1AojJ8GLLfxsp4Yy/S0UjnCESrVfOGp/4=";
  };

  vendorHash = "sha256-xAdaTu/DRtolP6tXge42ntJvq7Wi9gDErRfX1HZposc=";

  subPackages = [ "cmd/vulnx/" ];

  ldflags = [ "-s" ];

  strictDeps = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to work with CVEs";
    homepage = "https://github.com/projectdiscovery/vulnx";
    changelog = "https://github.com/projectdiscovery/vulnx/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "vulnx";
  };
})
