{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "tofu-ls";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "opentofu";
    repo = "tofu-ls";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q/SekYmQGJaYA5OxkUx6wYa6Tf1VXMtgAvRAkHfnuXo=";
  };

  vendorHash = "sha256-rGRhAAT0sGym0f4gkLEP/Xo9zIXO+O2cJJUMxg+miNM=";

  ldflags = [
    "-s"
    "-w"
  ];

  checkFlags =
    let
      skippedTests = [
        # Require network access
        "TestCompletion_moduleWithValidData"
        "TestCompletion_multipleModulesWithValidData"
        "TestCompletion_multipleModulesWithValidData"
        "TestExec_cancel"
        "TestLangServer_DidChangeWatchedFiles_moduleInstalled"
        "TestLangServer_workspace_symbol_basic"
        "TestLangServer_workspace_symbol_missing"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  __darwinAllowLocalNetworking = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "OpenTofu Language Server";
    homepage = "https://github.com/opentofu/tofu-ls";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "tofu-ls";
  };
})
