{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "wasmer-pack";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "wasmerio";
    repo = "wasmer-pack";
    rev = "v${version}";
    hash = "sha256-+wqgYkdkuhPFkJBdQLnUKAGmUfGBU9mBfMRNBFmiT4E=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-PZudXmdPz6fG7NDC/yN7qG+RQFSzNynXo6SpYJEku9A=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  cargoBuildFlags = [ "-p=wasmer-pack-cli" ];

  # requires internet access
  doCheck = false;

  meta = with lib; {
    description = "Import your WebAssembly code just like any other dependency";
    mainProgram = "wasmer-pack";
    homepage = "https://github.com/wasmerio/wasmer-pack";
    changelog = "https://github.com/wasmerio/wasmer-pack/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
