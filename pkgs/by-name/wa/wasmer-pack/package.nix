{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wasmer-pack";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "wasmerio";
    repo = "wasmer-pack";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+wqgYkdkuhPFkJBdQLnUKAGmUfGBU9mBfMRNBFmiT4E=";
  };

  cargoHash = "sha256-PZudXmdPz6fG7NDC/yN7qG+RQFSzNynXo6SpYJEku9A=";

  cargoBuildFlags = [ "-p=wasmer-pack-cli" ];

  # requires internet access
  doCheck = false;

  meta = {
    description = "Import your WebAssembly code just like any other dependency";
    mainProgram = "wasmer-pack";
    homepage = "https://github.com/wasmerio/wasmer-pack";
    changelog = "https://github.com/wasmerio/wasmer-pack/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
