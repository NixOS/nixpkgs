{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "wasmi";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "paritytech";
    repo = "wasmi";
    tag = "v${version}";
    hash = "sha256-3hMOkCF1h3P0+/Do5mZq9jlZtVnxdqZWxCCpXQyG+lM=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-IcZ9iB6Fqh53gTwKaUzuoQjkBEfWuM5MV0BM4JL8YkE=";
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Efficient WebAssembly interpreter";
    homepage = "https://github.com/paritytech/wasmi";
    changelog = "https://github.com/paritytech/wasmi/blob/${src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "wasmi_cli";
    maintainers = with lib.maintainers; [ dit7ya ];
  };
}
