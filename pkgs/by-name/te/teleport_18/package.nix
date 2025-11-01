{
  buildTeleport,
  buildGo124Module,
  wasm-bindgen-cli_0_2_99,
  withRdpClient ? true,
  extPatches ? [ ],
}:

buildTeleport {
  version = "18.2.2";
  hash = "sha256-q7HE3FXX3uxTP+sesMbPH6FbfhI7VsoXgrKKxPtfEtQ=";
  vendorHash = "sha256-w8RhvTKNhHKkwvsi6S3m0S9ZSxEO9bw/qhTHlB80lHc=";
  pnpmHash = "sha256-cpkV+B50JdhcXdI/K7cqJI6TsvGOCRxkFTJcA4wE5iQ=";
  cargoHash = "sha256-ia4We4IfIkqz82aFMVvXdzjDXw0w+OJSPVdutfau6PA=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_99;
  buildGoModule = buildGo124Module;
  inherit withRdpClient extPatches;
}
