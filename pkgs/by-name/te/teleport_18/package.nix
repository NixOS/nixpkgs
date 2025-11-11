{
  buildTeleport,
  buildGo124Module,
  wasm-bindgen-cli_0_2_99,
  withRdpClient ? true,
  extPatches ? [ ],
}:

buildTeleport {
  version = "18.3.1";
  hash = "sha256-HM0pu+3O7zoClH15YC0naxxmKJC9ngamnvraTosRqG0=";
  vendorHash = "sha256-HyS0KKW7lyn3NzedxM4+UxFV9OnxgtFDMW5jkj3ir/8=";
  pnpmHash = "sha256-6sThtwACNEdV0fleaQf3iMmFxPsd0AshYeYZUatFMcg=";
  cargoHash = "sha256-ia4We4IfIkqz82aFMVvXdzjDXw0w+OJSPVdutfau6PA=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_99;
  buildGoModule = buildGo124Module;
  inherit withRdpClient extPatches;
}
