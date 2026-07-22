{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "whale";
  version = "0.1.62";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "usewhale";
    repo = "Whale";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EvuNdgpW5M+i33tGLurQDq0z+Ht/z5agIsaWWapXqpY=";
  };

  vendorHash = "sha256-YBY5b2SLcWeiCQDZELJdsi+mJ+YEuo+yTbotUlLgqEA=";

  nativeCheckInputs = [
    gitMinimal
    writableTmpDirAsHomeHook
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-X=github.com/usewhale/whale/internal/build.Version=${finalAttrs.version}"
  ];

  excludedPackages = [ "cmd/dev" ];

  checkFlags = [
    # Fails in the sandbox
    "-skip=TestRulePolicyMCPPathOutsideWorkspaceRequiresExternalDirectoryApproval"
  ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal-first AI coding agent for DeepSeek";
    homepage = "https://github.com/usewhale/Whale";
    changelog = "https://github.com/usewhale/Whale/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "whale";
  };
})
