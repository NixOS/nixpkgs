{
  buildTeleport,
  buildGoModule,
  wasm-bindgen-cli_0_2_95,
  withRdpClient ? true,
  extPatches ? [ ],
}:

buildTeleport {
  version = "17.7.23";
  hash = "sha256-o1aYmNN4yytgJFQ7V1sPjq6r2pDzf4mG/juyYK5IF3A=";
  vendorHash = "sha256-cL2U1GOV6PtxSl8N8gjKOHCpj5jhun5D+DbeWBixnxI=";
  cargoHash = "sha256-cDcDfptq8z0pwjImuAovv/5XwoaPb/ostyxkyNEbkRM=";
  pnpmHash = "sha256-NTH5YnqeZg/jEkjguSXGS3/MI/r8us11By/fZ1m1caQ=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_95;
  inherit buildGoModule withRdpClient extPatches;
}
