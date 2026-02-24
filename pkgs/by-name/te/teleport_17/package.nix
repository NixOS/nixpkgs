{
  buildTeleport,
  buildGoModule,
  wasm-bindgen-cli_0_2_95,
  withRdpClient ? true,
  extPatches ? [ ],
}:

buildTeleport {
  version = "17.7.12";
  hash = "sha256-o4bepzHmPx9TfDBz0QsqQ9nd8o/WV1UTRDBnT1wM2yE=";
  vendorHash = "sha256-m4oeFuH+60UFBkK6BHil4X8BSHwCVrCJ0i0b5eNJLYE=";
  cargoHash = "sha256-qz8gkooQTuBlPWC4lHtvBQpKkd+nEZ0Hl7AVg9JkPqs=";
  pnpmHash = "sha256-I+uNfC9aAuFuCqRFdp442pW25F1G7rZwl+1s00i/wq0=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_95;
  inherit buildGoModule withRdpClient extPatches;
}
