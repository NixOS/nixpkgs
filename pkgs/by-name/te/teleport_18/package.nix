{
  buildTeleport,
  buildGo124Module,
  wasm-bindgen-cli_0_2_99,
}:

buildTeleport rec {
  version = "18.0.0-alpha.3";
  hash = "sha256-ZNNB8DQ/6+aPti4mnE3Ou1HftWv5KlIHdILCAZJ/zLg=";
  vendorHash = "sha256-oEgEuaqNVaLJk+Czkv7Cvyo5U/T9qDWW6vmn955lUgA=";
  pnpmHash = "sha256-3046GvSk/vzlJHLyZTy7BzUxqHqkCSI/XOhKGtWb0pI=";
  cargoHash = "sha256-ia4We4IfIkqz82aFMVvXdzjDXw0w+OJSPVdutfau6PA=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_99;
  buildGoModule = buildGo124Module;
}
