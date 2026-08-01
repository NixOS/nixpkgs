{
  lib,
  stdenv,
  fetchFromGitHub,
  rust-jemalloc-sys,
  installShellFiles,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zizmor";
  version = "1.28.0";

  src = fetchFromGitHub {
    owner = "zizmorcore";
    repo = "zizmor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-T4Ww5PAcRZmCyBt142gBcQ8Mj6Rswj3QO+W/nCvqlNI=";
  };

  cargoHash = "sha256-0buSU2wg3Yx3pE4rlESyukbFcZ7kReFmr3H2yHV5Unk=";

  buildInputs = [
    rust-jemalloc-sys
  ];

  nativeBuildInputs = lib.optionals (stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    installShellFiles
  ];

  checkFlags = [
    # need network
    "--skip=audit::known_vulnerable_actions::tests::test_first_patched_version_priority"
    "--skip=audit::known_vulnerable_actions::tests::test_fix_symbolic_ref"
    "--skip=audit::known_vulnerable_actions::tests::test_fix_upgrade_action_with_subpath"
    "--skip=audit::known_vulnerable_actions::tests::test_fix_upgrade_actions_checkout"
    "--skip=audit::known_vulnerable_actions::tests::test_fix_upgrade_actions_setup_node"
    "--skip=audit::known_vulnerable_actions::tests::test_fix_upgrade_multiple_vulnerable_actions"
    "--skip=audit::known_vulnerable_actions::tests::test_fix_upgrade_third_party_action"
    # insta snapshot appears to depend on checkout structure
    "--skip=e2e::issue_1745"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd zizmor \
      --bash <("$out/bin/zizmor" --completions bash) \
      --zsh <("$out/bin/zizmor" --completions zsh) \
      --fish <("$out/bin/zizmor" --completions fish)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^v([0-9.]+\\.[0-9.]+\\.[0-9.])+$" ];
  };

  meta = {
    description = "Tool for finding security issues in GitHub Actions setups";
    homepage = "https://docs.zizmor.sh/";
    changelog = "https://github.com/zizmorcore/zizmor/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lesuisse ];
    mainProgram = "zizmor";
  };
})
