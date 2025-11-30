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
  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "zizmorcore";
    repo = "zizmor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d9DfDqtAI7UvADI8QnbjES0phBBfit6CQ0Osj9ckqlU=";
  };

  cargoHash = "sha256-lF8Z+fe8x+PbXvcJABn58VMU+4pBJOGUeW+PhZXxCTU=";

  buildInputs = [
    rust-jemalloc-sys
  ];

  nativeBuildInputs = lib.optionals (stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    installShellFiles
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
    extraArgs = [ "--version-regex=^v([0-9.]+\.[0-9.]+\.[0-9.])+$" ];
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
