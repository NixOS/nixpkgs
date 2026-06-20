{
  buildTeleport,
  buildGo125Module,
  wasm-bindgen-cli_0_2_99,
  withRdpClient ? true,
  extPatches ? [ ],
}:

buildTeleport {
  version = "18.8.3";
  hash = "sha256-DHPOWIvzBCOT3GU0YHBtG46ctB0Nh8XwSmpl9vgCET8=";
  vendorHash = "sha256-0+fIoprAQyoom9xBpXGiEgmE4dWktcqlZQOzkRXYlKo=";
  pnpmHash = "sha256-8FlC9Sm12A5kfS9X0qYDNJOePZjeJU7LDTRlWUIEneA=";
  cargoHash = "sha256-IX0HCeCosXCe/oTYa8PImemf9op2AeagSnl44uBnSbM=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_99;
  buildGoModule = buildGo125Module;
  inherit withRdpClient extPatches;
}
