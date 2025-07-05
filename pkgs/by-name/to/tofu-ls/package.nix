{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  unstableGitUpdater,
}:

buildGoModule (finalAttrs: {
  pname = "tofu-ls";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "opentofu";
    repo = "tofu-ls";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ioUhESBnGhVxeJQ+0lZ4tjfCWbc3mS2o584EXuXIqso=";
  };

  vendorHash = "sha256-rUvqIebAhnR9b/RAiW8Md/D8NgDDKro1XodXSCtstjA=";

  ldflags = [
    "-s"
    "-w"
    "-X 'main.rawVersion=${finalAttrs.version}'"
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

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = {
    description = "OpenTofu Language Server";
    homepage = "https://github.com/opentofu/tofu-ls";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "tofu-ls";
  };
})
