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
    owner = "paritytech";
    repo = "wasmi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+hzvJ0Jq2tFxbCBSSjnUHgZDRb7q0+OGEzMtjZU20Fg=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-8RVKZYMB5ieAnwHpjFloEmswUT8BbSRaSmduaoOa+io=";
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Efficient WebAssembly interpreter";
    homepage = "https://github.com/paritytech/wasmi";
    changelog = "https://github.com/paritytech/wasmi/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "wasmi_cli";
    maintainers = with lib.maintainers; [ dit7ya ];
  };
})
