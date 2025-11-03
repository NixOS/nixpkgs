{
  buildTeleport,
  buildGoModule,
  wasm-bindgen-cli_0_2_95,
  withRdpClient ? true,
  extPatches ? [ ],
}:
buildTeleport {
  version = "16.5.16";
  hash = "sha256-b1jUr36KNgiZnA3QBo2blKxjK3Sy6S6Lrc/bzWsX20Q=";
  vendorHash = "sha256-mcDybNt7Mr0HJW272Ulj1oWlfsH2kEp7rNyeonoIjf8=";
  pnpmHash = "sha256-+vZXacdGkLvjYN1s0Z+/JiVjxiaOGJ3326PvWtFaFaI=";
  cargoHash = "sha256-04zykCcVTptEPGy35MIWG+tROKFzEepLBmn04mSbt7I=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_95;
  inherit buildGoModule withRdpClient extPatches;
}
