{
  buildTeleport,
  buildGo125Module,
  wasm-bindgen-cli_0_2_122,
  withRdpClient ? true,
  extPatches ? [ ],
}:

buildTeleport {
  version = "18.9.2";
  hash = "sha256-w6qCH57L2rwClbSpZeG01eekzj3JRNijwSdfl+wx8v8=";
  vendorHash = "sha256-LJmpFHvFsBsneq1Cl3vvqxBGB94gSjaikNDZtQfwNjM=";
  pnpmHash = "sha256-8tKVv5SPJlS89EsHhF8qpThkh4n47qRBbHDCgX17Cdg=";
  cargoHash = "sha256-+B5fGIzCpiYmqVcM4iy+PTIdtvuvtufQiXMHNzHTDlQ=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_122;
  buildGoModule = buildGo125Module;
  inherit withRdpClient extPatches;
}
