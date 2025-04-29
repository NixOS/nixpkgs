{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "wasmi";
  version = "0.44.0";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "wasmi";
    tag = "v${version}";
    hash = "sha256-tKUkcuVT2945+pf7qdCgbUYbtiZmfE7tfzRlf8H/GkU=";
    fetchSubmodules = true;
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-1p/cibicoH39+/Xrf28W2jOWK23LVu7L0nnsVDgvIV8=";
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
