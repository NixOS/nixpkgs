{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "tofu-ls";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "opentofu";
    repo = "tofu-ls";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CfaF8HNG1O5clTDZcSMUwAda2hbJbOQJ34GzUSBYqoQ=";
  };

  vendorHash = "sha256-CwfkDqmdG77OojyCM0nLPA8d8ma1+pzIyeQUeQMkXEY=";

  ldflags = [
    "-s"
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
