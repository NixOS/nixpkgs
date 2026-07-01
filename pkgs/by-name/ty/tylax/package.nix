{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tylax";
  version = "0.3.6";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "scipenai";
    repo = "tylax";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UdFO378x/8ewmjvTH1c6aUGGLIa8NL0n7VIvtZeRdQw=";
  };

  cargoHash = "sha256-4l5Xy/+si40mqrZsZK3d/Andt1kZ8KK1rpFglR9KSow=";

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
