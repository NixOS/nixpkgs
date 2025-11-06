{
  buildTeleport,
  buildGoModule,
  wasm-bindgen-cli_0_2_95,
  withRdpClient ? true,
  extPatches ? [ ],
}:

buildTeleport {
  version = "17.7.8";
  hash = "sha256-z520UT17nFLBwyVLjdfx9aTbkMv1fljsN88G6WRPvZE=";
  vendorHash = "sha256-mtOCLAcVIxaEhGzdsVWxnKQ4FRTXZ5vVAF+NVMdFItk=";
  cargoHash = "sha256-qz8gkooQTuBlPWC4lHtvBQpKkd+nEZ0Hl7AVg9JkPqs=";
  pnpmHash = "sha256-4xLbPQwmI0nAUNAgDHwkx1uSbjHPe8LNmEFQfoaj6bY=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_95;
  inherit buildGoModule withRdpClient extPatches;
}
