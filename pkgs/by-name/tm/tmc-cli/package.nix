{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  writableTmpDirAsHomeHook,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tmc-cli";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "rage";
    repo = "tmc-cli-rust";
    tag = "v${finalAttrs.version}";
    hash = "sha256-P6jlj9HWZ09vAw7EVT8po49eWGkGv/ppvKwnq06t2A0=";
  };

  cargoHash = "sha256-YUIEKr1nQij4f/4kOeJq6AgqeQq+U3bOBTJaJM2Bs2Y=";

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # When sandboxing, "Attempted to create a NULL object."
    # https://github.com/mullvad/system-configuration-rs/pull/59 may fix.
    "--skip=commands::courses::tests::list_courses_with_client_test"
    # Same
    "--skip=all_integration_tests"
    # When sandboxing, "Lazy instance has previously been poisoned."
    "--skip=commands::exercises::tests::list_exercises_with_client_test"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "CLI for using the TestMyCode programming assignment evaluator";
    homepage = "https://github.com/rage/tmc-cli-rust";
    changelog = "https://github.com/rage/tmc-cli-rust/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hekazu ];
    mainProgram = "tmc";
  };
})
