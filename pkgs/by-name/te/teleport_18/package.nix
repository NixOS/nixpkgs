{
  buildTeleport,
  buildGo124Module,
  wasm-bindgen-cli_0_2_99,
  withRdpClient ? true,
  extPatches ? [ ],
}:

buildTeleport {
  version = "18.6.5";
  hash = "sha256-xNdNyWpH1NpF8O9BLsiov3mmnrXXr/kbi2zbEaGDGNg=";
  vendorHash = "sha256-sXBCfzVjffSyPDIxmAWFp1WINmMPV1HRx9O6JkOgqLM=";
  pnpmHash = "sha256-aHiBD/GYK5zal2NeBzaDEftzruPwoSwARz/2uuqyKlY=";
  cargoHash = "sha256-tp+xxa+sYQpvgD2Yv/W0hegRpUubBeFpdngRyByNxJc=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_99;
  buildGoModule = buildGo124Module;
  inherit withRdpClient extPatches;
}
