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
  version = "0.8.14";

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "uv";
    tag = finalAttrs.version;
    hash = "sha256-KG6WNaHbrPBasHdSdtWrnvzwMRrvpwukVSIZe3COrUA=";
  };

  cargoHash = "sha256-Ow39kxnACXVbEtCPGJJ7SKdTFhYwd9IDPbYAsvNPOKw=";

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

    # Updating `uv` needs to be done on staging. Disabling r-ryantm update bot:
    # nixpkgs-update: no auto update
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

    # Builds on 32-bit platforms fails with "out of memory" since at least 0.8.6.
    # We don't place this in `badPlatforms` because cross-compilation on 64-bit
    # machine may work, e.g. `pkgsCross.gnu32.uv`.
    broken = stdenv.buildPlatform.is32bit;
  };
})
