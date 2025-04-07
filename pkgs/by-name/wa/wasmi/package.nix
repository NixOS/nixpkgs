{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "wasmi";
  version = "0.43.0";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "wasmi";
    tag = "v${version}";
    hash = "sha256-h8eViInYiq0HhdYtqjurOOw93to+J5NsOdFXJYZsl8g=";
    fetchSubmodules = true;
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-f4oN82T/PepntbDsFTugZkYclaeQXMPAxoV7R7gtqf0=";
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
