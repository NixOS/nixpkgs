{
  buildTeleport,
  buildGo124Module,
  wasm-bindgen-cli_0_2_99,
}:

buildTeleport rec {
  version = "18.2.0";
  hash = "sha256-JWgGRv9pK76u7IxwqnBcuAI93XIKfIVvme7l+a/3J7c=";
  vendorHash = "sha256-oPi/rIuwze2ZlyHfZ2MdDHHvdIaF2IZ2aklEVNRgoLo=";
  pnpmHash = "sha256-wW4RT1uqOTpy8wKIsAOfIlxoOamTzPqEbFQRAub+sn4=";
  cargoHash = "sha256-ia4We4IfIkqz82aFMVvXdzjDXw0w+OJSPVdutfau6PA=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_99;
  buildGoModule = buildGo124Module;
}
