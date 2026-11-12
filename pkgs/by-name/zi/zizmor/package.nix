{
  lib,
  stdenv,
  fetchFromGitHub,
  aws-lc,
  rust-jemalloc-sys,
  installShellFiles,
  nix-update-script,
  pkg-config,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zizmor";
  version = "1.32.0";

  src = fetchFromGitHub {
    owner = "zizmorcore";
    repo = "zizmor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wBBMF6FNwzlJiVag5tE64YnDf5Se+J5kJ/beVfg9H/Q=";
  };

  cargoHash = "sha256-b7tcTvECEFb1fBVSo6y+NL4YognKuOBjAVMIyrCXZGQ=";

  buildInputs = [
    aws-lc
    rust-jemalloc-sys
  ];

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals (stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    installShellFiles
  ];

  checkFlags = [
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
