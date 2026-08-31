{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tylax";
  version = "0.3.7";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "scipenai";
    repo = "tylax";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XwgSBEJ0Y9Tuxivlizht7uGaRJMI45vZhaXZBVXxbTI=";
  };

  cargoHash = "sha256-AI1RXI1U7x7xU5GuzPsKpF3f5KeoXB7kYVxWITue9Xs=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "High-performance bidirectional LaTeX and Typst converter";
    homepage = "https://github.com/scipenai/tylax";
    changelog = "https://github.com/scipenai/tylax/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "t2l";
    maintainers = with lib.maintainers; [ kilianar ];
    platforms = lib.platforms.unix;
  };
})
