{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,

  # nativeBuildInputs
  installShellFiles,

  buildPackages,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ty";
  version = "0.0.1-alpha.15";

  src = fetchFromGitHub {
    owner = "astral-sh";
    repo = "ty";
    tag = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-7aOFRrnj4WFTuQWcOgdSU3w9KWwRbpPj3K6g4y0JPo0=";
  };

  # For Darwin platforms, remove the integration test for file notifications,
  # as these tests fail in its sandboxes.
  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    rm ${finalAttrs.cargoRoot}/crates/ty/tests/file_watching.rs
  '';

  cargoRoot = "ruff";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoBuildFlags = [ "--package=ty" ];

  cargoHash = "sha256-vhsXYqU3Y5xGDLE/AVkVIY4eweHbyR/E3RvGoHG+1ZE=";

  nativeBuildInputs = [ installShellFiles ];

  # `ty`'s tests use `insta-cmd`, which depends on the structure of the `target/` directory,
  # and also fails to find the environment variable `$CARGO_BIN_EXE_ty`, which leads to tests failing.
  # Instead, we specify the path ourselves and forgo the lookup.
  # As the patches occur solely in test code, they have no effect on the packaged `ty` binary itself.
  #
  # `stdenv.hostPlatform.rust.cargoShortTarget` is taken from `cargoSetupHook`'s `installPhase`,
  # which constructs a path as below to reference the built binary.
  preCheck = ''
    export CARGO_BIN_EXE_ty="$PWD"/target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/ty
  '';

  cargoTestFlags = [
    "--package=ty" # CLI tests; file-watching tests only on Linux platforms
    "--package=ty_python_semantic" # core type checking tests
    "--package=ty_test" # test framework tests
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  postInstall =
    let
      exe =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          "$out/bin/ty"
        else
          lib.getExe buildPackages.ty;
    in
    ''
      installShellCompletion --cmd ty \
        --bash <(${exe} generate-shell-completion bash) \
        --fish <(${exe} generate-shell-completion fish) \
        --zsh <(${exe} generate-shell-completion zsh)
    '';

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--version=unstable" ]; };
  };

  meta = {
    description = "Extremely fast Python type checker and language server, written in Rust";
    homepage = "https://github.com/astral-sh/ty";
    changelog = "https://github.com/astral-sh/ty/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "ty";
    maintainers = with lib.maintainers; [
      bengsparks
      GaetanLepage
    ];
  };
})
