{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wasmi";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "wasmi-labs";
    repo = "wasmi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-54mZxX7ygmX93V3l1ZRqDdbGe5uk772GSaNmXnV3iEQ=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-v38ThWgelSmxWLhOHqmJIbh1sisB1K56825ut/mZoMs=";
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
    mainProgram = "wasmi_cli";
  };
})
