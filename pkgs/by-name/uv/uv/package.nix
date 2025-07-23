{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,

  # buildInputs
  rust-jemalloc-sys,

  # nativeBuildInputs
  installShellFiles,

  buildPackages,
  versionCheckHook,
  python3Packages,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "uv";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "uv";
    tag = finalAttrs.version;
    hash = "sha256-iVwiXen/VNxXQxlF7cg9qGz61cEoszNgWB3XHdl750I=";
  };

  cargoHash = "sha256-Bw8/AAGcdE3qL0TENj4hMrOG89MLUQauMfpTmlgXdk8=";

  buildInputs = [
    rust-jemalloc-sys
  ];

  nativeBuildInputs = [ installShellFiles ];

  cargoBuildFlags = [
    "--package"
    "uv"
  ];

  # Tests require python3
  doCheck = false;

  postInstall =
    let
      exe =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          "$out/bin/uv"
        else
          lib.getExe buildPackages.uv;
    in
    ''
      installShellCompletion --cmd uv \
        --bash <(${exe} generate-shell-completion bash) \
        --fish <(${exe} generate-shell-completion fish) \
        --zsh <(${exe} generate-shell-completion zsh)
    '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    tests.uv-python = python3Packages.uv;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Extremely fast Python package installer and resolver, written in Rust";
    homepage = "https://github.com/astral-sh/uv";
    changelog = "https://github.com/astral-sh/uv/blob/${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      bengsparks
      GaetanLepage
      prince213
    ];
    mainProgram = "uv";
  };
})
