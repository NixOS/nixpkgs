{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  testers,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wasmi";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "wasmi-labs";
    repo = "wasmi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-b9Fuh07wRgfo+FYFbbH4y0DYw83ScZlhwUV5c4qkPYw=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-op4QB2akkeO2MJHo25gPS5ZFYEYzqSAfcPkPrKA653s=";

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Efficient and versatile WebAssembly interpreter for embedded systems";
    homepage = "https://github.com/wasmi-labs/wasmi";
    changelog = "https://github.com/wasmi-labs/wasmi/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "wasmi";
  };
})
