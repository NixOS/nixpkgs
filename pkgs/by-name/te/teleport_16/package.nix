{
  buildTeleport,
  buildGoModule,
  wasm-bindgen-cli_0_2_95,
  withRdpClient ? true,
  extPatches ? [ ],
}:
buildTeleport {
  version = "16.5.18";
  hash = "sha256-Dikw4y62V7S62K+8EqltXM4RRYPgE2Ad/kZrSS2TEDo=";
  vendorHash = "sha256-mcDybNt7Mr0HJW272Ulj1oWlfsH2kEp7rNyeonoIjf8=";
  pnpmHash = "sha256-Sn3rM6l6pADG7GHenlL3NC0oLc4GFZLTzqDHgzInLbk=";
  cargoHash = "sha256-04zykCcVTptEPGy35MIWG+tROKFzEepLBmn04mSbt7I=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_95;
  inherit buildGoModule withRdpClient extPatches;
}
