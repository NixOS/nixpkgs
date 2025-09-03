{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "wasmi";
  version = "0.51.1";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "wasmi";
    tag = "v${version}";
    hash = "sha256-Y9wHrx5UcUzJOJoMq9oPgblrpRjLe9nX79FZxL2cIgY=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-tlvk+UAUMGToWaRbpsvI8eqsYrnoV/pvn+pWvbOv/18=";
  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Efficient WebAssembly interpreter";
    homepage = "https://github.com/paritytech/wasmi";
    changelog = "https://github.com/paritytech/wasmi/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [
      asl20
      mit
    ];
    mainProgram = "wasmi_cli";
    maintainers = with maintainers; [ dit7ya ];
  };
}
