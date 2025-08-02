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
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "uv";
    tag = finalAttrs.version;
    hash = "sha256-qMXXkf2hLyzd+4H85kGHiQIdAbvhMA2z+1z05ZF0hts=";
  };

  cargoHash = "sha256-G5mLFKy/khHlP32/VFudtJJC1CWpBNyx4yPx1Gc8pcY=";

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
    longDescription = ''
      `uv` manages project dependencies and environments, with support for lockfiles, workspaces, and more.

      When running `uv` on NixOS systems, make sure to use `UV_PYTHON` or `--python`, where applicable, to pass a path to a compatible interpreter
      via dev-shell (e.g. `UV_PYTHON=''${pkgs.python313}`), .env file, or from the command line, as NixOS cannot run dynamically
      linked executables intended for generic Linux environments out of the box.

      For building Python projects with uv and Nix outside of nixpkgs, check out `uv2nix` at https://github.com/pyproject-nix/uv2nix.
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
  };
})
