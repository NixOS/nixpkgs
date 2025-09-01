{
  buildTeleport,
  buildGo124Module,
  wasm-bindgen-cli_0_2_99,
}:

buildTeleport rec {
  version = "18.1.1";
  hash = "sha256-xhf6WwgR3VwjtvFo0/b9A0RcyY7dklPfPUakludUmm8=";
  vendorHash = "sha256-63pqTI92045/V8Gf+TDKUWLV9eO4hVKOHtgWbYnAf6I=";
  pnpmHash = "sha256-ZuMMacsyr2rGLVDlaEwA7IbZZfGBuTRBOv4Q6XIjDek=";
  cargoHash = "sha256-ia4We4IfIkqz82aFMVvXdzjDXw0w+OJSPVdutfau6PA=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_99;
  buildGoModule = buildGo124Module;
}
