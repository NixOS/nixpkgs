{
  buildTeleport,
  buildGo123Module,
  wasm-bindgen-cli_0_2_95,
}:

buildTeleport rec {
  version = "17.5.4";
  hash = "sha256-ojRIyPTrSG3/xuqdaUNrN4s5HP3E8pvzjG8h+qFEYrc=";
  vendorHash = "sha256-IHXwCp1MdcEKJhIs9DNf77Vd93Ai2as7ROlh6AJT9+Q=";
  cargoHash = "sha256-qz8gkooQTuBlPWC4lHtvBQpKkd+nEZ0Hl7AVg9JkPqs=";
  pnpmHash = "sha256-YwftGEQTEI8NvFTFLMJHhYkvaIIP9+bskCQCp5xuEtY=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_95;
  buildGoModule = buildGo123Module;
}
