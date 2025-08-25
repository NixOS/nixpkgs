{
  buildTeleport,
  buildGo123Module,
  wasm-bindgen-cli_0_2_95,
}:

buildTeleport rec {
  version = "17.7.0";
  hash = "sha256-+NfYpA6BDpD0/YCMj2y2torgw/ihd279SLTmPySIqvk=";
  vendorHash = "sha256-NWZKLiub68OR0U3RkCOLCe4vrzXdOCitYm3ITOU3nhk=";
  cargoHash = "sha256-qz8gkooQTuBlPWC4lHtvBQpKkd+nEZ0Hl7AVg9JkPqs=";
  pnpmHash = "sha256-I1mQ/F1ethOPA0jlrN+3ClByk7Ifw6LPbgjSvPx44D4=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_95;
  buildGoModule = buildGo123Module;
}
