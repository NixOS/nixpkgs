{
  lib,
  fetchFromGitHub,
  rustPlatform,
  writableTmpDirAsHomeHook,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tmc-cli";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "rage";
    repo = "tmc-cli-rust";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C7X+XTOqquqf/W29+A4wUUl6aDZYLlc5XokkIOrCbp0=";
  };

  cargoHash = "sha256-2KoHKTN1Jvyvk9ravi0a9D+RIFYa1KmHLJQzKT2iP9A=";

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";
  versionCheckProgramArg = "--version";

  meta = {
    description = "CLI for using the TestMyCode programming assignment evaluator";
    homepage = "https://github.com/rage/tmc-cli-rust";
    changelog = "https://github.com/rage/tmc-cli-rust/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hekazu ];
    mainProgram = "tmc";
  };
})
