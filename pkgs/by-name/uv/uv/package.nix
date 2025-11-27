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
  version = "0.9.13";

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "uv";
    tag = finalAttrs.version;
    hash = "sha256-KhJN9aYWeeo3Hc7pprNkzTZS2xsogdJmK5rDKlcjWp4=";
  };

  cargoHash = "sha256-IZ168ImtJ4iBz23KOZzY27urHpj+PexE8IGco0Kd1eg=";

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
  doInstallCheck = true;

  passthru = {
    tests.uv-python = python3Packages.uv;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Extremely fast Python package installer and resolver, written in Rust";
    longDescription = ''
      `uv` manages project dependencies and environments, with support for lockfiles, workspaces, and more.

      Due to `uv`'s (over)eager fetching of dynamically-linked Python executables,
      as well as vendoring of dynamically-linked libraries within Python modules distributed via PyPI,
      NixOS users can run into issues when managing Python projects.
      See the Nixpkgs Reference Manual entry for `uv` for information on how to mitigate these issues:
      https://nixos.org/manual/nixpkgs/unstable/#sec-uv.

      For building Python projects with `uv` and Nix outside of nixpkgs, check out `uv2nix` at https://github.com/pyproject-nix/uv2nix.
    '';
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
