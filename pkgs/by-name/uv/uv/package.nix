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
  version = "0.7.7";

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "uv";
    tag = finalAttrs.version;
    hash = "sha256-QWqN8MAIyr8ZvzdznpmR4KJNF0znEkBBb3ASBXBbqns=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-HaalXfQO1cMDZM3jRa35fEU0zQ3BVD1JiuB/AIxcPc0=";

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

  postInstall = lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      installShellCompletion --cmd uv \
        --bash <(${emulator} $out/bin/uv generate-shell-completion bash) \
        --fish <(${emulator} $out/bin/uv generate-shell-completion fish) \
        --zsh <(${emulator} $out/bin/uv generate-shell-completion zsh)
    ''
  );

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
