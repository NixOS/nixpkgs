{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wasmi";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "wasmi-labs";
    repo = "wasmi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+hzvJ0Jq2tFxbCBSSjnUHgZDRb7q0+OGEzMtjZU20Fg=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-8RVKZYMB5ieAnwHpjFloEmswUT8BbSRaSmduaoOa+io=";
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
