{
  buildTeleport,
  buildGo124Module,
  wasm-bindgen-cli_0_2_99,
}:

buildTeleport rec {
  version = "18.0.0-alpha.2";
  hash = "sha256-KydCLPZ0YadkukPcUsRXyg917LKTplCXikS7peRu/i8=";
  vendorHash = "sha256-oEgEuaqNVaLJk+Czkv7Cvyo5U/T9qDWW6vmn955lUgA=";
  pnpmHash = "sha256-3046GvSk/vzlJHLyZTy7BzUxqHqkCSI/XOhKGtWb0pI=";
  cargoHash = "sha256-ia4We4IfIkqz82aFMVvXdzjDXw0w+OJSPVdutfau6PA=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_99;
  buildGoModule = buildGo124Module;
}
