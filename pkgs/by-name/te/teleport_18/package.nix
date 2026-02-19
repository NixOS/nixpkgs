{
  buildTeleport,
  buildGo124Module,
  wasm-bindgen-cli_0_2_99,
  withRdpClient ? true,
  extPatches ? [ ],
}:

buildTeleport {
  version = "18.6.6";
  hash = "sha256-I5tnWOnQrcOwhK2SCtkhvR/PkTWxfk0R0yDGJwyxh9E=";
  vendorHash = "sha256-sXBCfzVjffSyPDIxmAWFp1WINmMPV1HRx9O6JkOgqLM=";
  pnpmHash = "sha256-/MJL/VPQxijOyvboUl4+sctAP+5YA4R0luOqmMe8f94=";
  cargoHash = "sha256-tp+xxa+sYQpvgD2Yv/W0hegRpUubBeFpdngRyByNxJc=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_99;
  buildGoModule = buildGo124Module;
  inherit withRdpClient extPatches;
}
