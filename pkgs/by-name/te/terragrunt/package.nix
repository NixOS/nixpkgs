{
  lib,
  stdenv,

  buildGoModule,
  fetchFromGitHub,

  installShellFiles,

  gitMinimal,
  gitSetupHook,
  opentofu,
  writableTmpDirAsHomeHook,

  buildPackages,

  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "terragrunt";
  version = "1.1.3";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = "terragrunt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JovTD88P/9IUX1y1AG/NhkIRRPCa0eAwJSx5qfg+4Ck=";
  };

  proxyVendor = true;

  vendorHash = "sha256-eqoT9On/nGwJIbWug4RQVmibbsqbTRa5MzOoFXgGmxc=";

  nativeBuildInputs = [
    installShellFiles
  ];

  excludedPackages = [
    # utility for identifying flakey tests
    "test/flake"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/gruntwork-io/terragrunt/internal/version.Version=v${finalAttrs.version}"
  ];

  nativeCheckInputs = [
    # required for git to resolve $HOME/.gitconfig
    # terragrunt's CAS feature also wants to write inside $HOME
    writableTmpDirAsHomeHook
    gitSetupHook
    # needs to run git mid test
    gitMinimal
    opentofu
  ];

  preCheck = ''
    # make executable so it's a valid target for `patchShebangs`
    chmod +x test/fixtures/feature-flags/run-all-isolated-defaults/fake-tf.sh

    # patch scripts used in tests
    patchShebangs \
      internal/os/exec/testdata \
      internal/tf/testdata \
      internal/shell/testdata \
      test/fixtures/

    # prep directory so git commands during testing will work
    git config --global init.defaultBranch master
    git init
    # dir needs to be part of history
    git add test/fixtures/config-terraform-functions
    git commit --quiet --message "initial commit"
  '';

  checkFlags =
    let
      skippedTests = [
        # calls out to the internet
        "TestToSourceUrl"
        # requires cloning it's own terragrunt repo via github.com
        "TestCatalogWithLocalDefaultTemplate"
        # requires cloning https://github.com/gruntwork-io/terraform-fake-modules.git/
        "TestScaffoldGitModule"
        "TestScaffoldGitRepo"
        # requires cloning https://github.com/Azure/terraform-azurerm-avm-res-compute-virtualmachine.git
        "TestScaffold3rdPartyModule"
        # requires terraform
        "TestDependencyOutputSkipDependencyOutputsFlag"
        "TestCatalogGitRepoUpdate"
        "TestRunAllHonorsTerraformBinaryWithBothOnPath"
        # requires remote terraform/tofu providers
        "TestTerragruntFullLockfile"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  postInstall =
    let
      cmd = finalAttrs.meta.mainProgram;
      exe =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          "$out/bin/${cmd}"
        else
          lib.getExe buildPackages.terragrunt;
    in
    ''
      # terragrunt will only directly install completions
      # completion install looks for expected file paths for a shell or it wont do an install
      # provide the fish dir it looks for
      mkdir -p ./completion/fish
      export COMPLETION_DIR="$PWD/completion"

      # go's os/user.Current which looks in /etc/passwd with no $HOME override
      XDG_CONFIG_HOME="$COMPLETION_DIR" ${exe} --install-autocomplete
      installShellCompletion --cmd ${cmd} \
        --fish "$COMPLETION_DIR/fish/completions/${cmd}.fish"
    '';

  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    homepage = "https://terragrunt.com/";
    changelog = "https://github.com/gruntwork-io/terragrunt/releases/tag/v${finalAttrs.version}";
    description = "Terragrunt is a flexible orchestration tool that allows Infrastructure as Code written in OpenTofu/Terraform to scale";
    mainProgram = "terragrunt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jk
      qjoly
      kashw2
    ];
  };
})
