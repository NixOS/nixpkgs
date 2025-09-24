{
  buildTeleport,
  buildGoModule,
  wasm-bindgen-cli_0_2_95,
}:

buildTeleport rec {
  version = "17.7.3";
  hash = "sha256-YSYkJRAeu7iPOs/gFnozZbks0Fx5srNH0VjrKvFmHZo=";
  vendorHash = "sha256-7Rb94ERtp3H1Jwyh9d7AFT06d4xXdnfe5tpdvJQrbUQ=";
  cargoHash = "sha256-qz8gkooQTuBlPWC4lHtvBQpKkd+nEZ0Hl7AVg9JkPqs=";
  pnpmHash = "sha256-ZONs8z8mgBBQBmqaDGJKqhmtUKBrxE8BGYppbAqpQmg=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_95;
  inherit buildGoModule;
}
