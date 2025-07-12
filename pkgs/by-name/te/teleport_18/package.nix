{
  buildTeleport,
  buildGo124Module,
  wasm-bindgen-cli_0_2_99,
}:

buildTeleport rec {
  version = "18.0.0";
  hash = "sha256-HcysabG071TWQyhIWWACC7njqFSljQXzmGBIUcD3Sh4=";
  vendorHash = "sha256-/PNJO4fdk134bFR5u4hNgoz38FjcJQ0o5ZKS8lHpj/Y=";
  pnpmHash = "sha256-mWAhzwayRMvgjUfNoG5QbFIlkQNit5bOcge06baeLxY=";
  cargoHash = "sha256-ia4We4IfIkqz82aFMVvXdzjDXw0w+OJSPVdutfau6PA=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_99;
  buildGoModule = buildGo124Module;
}
