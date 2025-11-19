{
  buildTeleport,
  buildGo124Module,
  wasm-bindgen-cli_0_2_99,
  withRdpClient ? true,
  extPatches ? [ ],
}:

buildTeleport {
  version = "18.4.0";
  hash = "sha256-QliroT1xJYFJvY52FCFzBY9BO3GImTy5bcWh4Z2hvHU=";
  vendorHash = "sha256-ltPdDqUJeLYG+uHUqq3JMKlI2Bvz7yOO81NtPRMhd2A=";
  pnpmHash = "sha256-GqWNHhltgSQkT0M7Y0vfJ6gLiVAZ03KdjrnqGOJhoNs=";
  cargoHash = "sha256-ia4We4IfIkqz82aFMVvXdzjDXw0w+OJSPVdutfau6PA=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_99;
  buildGoModule = buildGo124Module;
  inherit withRdpClient extPatches;
}
