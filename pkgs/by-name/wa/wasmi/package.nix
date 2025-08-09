{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "wasmi";
  version = "0.47.0";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "wasmi";
    tag = "v${version}";
    hash = "sha256-N2zEc+++286FBJl6cGh8ibOvHHwMnh4PcOLaRhB/rC0=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-asl8saHlZ5A05QFs2pSs6jMM6AI29c4DTPu4zw+FMug=";
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
