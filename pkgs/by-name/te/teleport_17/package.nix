{
  buildTeleport,
  buildGoModule,
  wasm-bindgen-cli_0_2_95,
  withRdpClient ? true,
  extPatches ? [ ],
}:

buildTeleport {
  version = "17.7.24";
  hash = "sha256-45vaxznxRfa4X/V7hZsQKVIWvbVG8F2cEQN19xp4WQg=";
  vendorHash = "sha256-ERwCdWdp230wkqsRUCnd1hbO4PqXo+gDPsoGbxQqt04=";
  cargoHash = "sha256-cDcDfptq8z0pwjImuAovv/5XwoaPb/ostyxkyNEbkRM=";
  pnpmHash = "sha256-hk9DI3GSBm2XttCYCi5kjhEhUMm5ToRQcbT+RYI+S2Q=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_95;
  inherit buildGoModule withRdpClient extPatches;
}
