{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "wasmi";
  version = "0.51.0";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "wasmi";
    tag = "v${version}";
    hash = "sha256-mPArNkPrTW3RikLlQNkAjIUEfRot2nRaqceNopGmZDo=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-7L2XQ4E+1wyNMu2IEgqvKuY84k7kQ07m/dXbyDYN/VU=";
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
