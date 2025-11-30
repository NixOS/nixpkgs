{
  buildTeleport,
  buildGo124Module,
  wasm-bindgen-cli_0_2_99,
  withRdpClient ? true,
  extPatches ? [ ],
}:

buildTeleport {
  version = "18.4.1";
  hash = "sha256-cwOq7FcjF3TqVHGAdH42zeVQ89TFThjZprO+prgcYdw=";
  vendorHash = "sha256-9pvwnrHTLLS3KIUG4EIoTIVJVF6fqy++jkz/O15MQ9U=";
  pnpmHash = "sha256-lwRNrprOb7YVkYRvXyWTyKNNQcm9XBrIeSsi75w4iNM=";
  cargoHash = "sha256-ia4We4IfIkqz82aFMVvXdzjDXw0w+OJSPVdutfau6PA=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_99;
  buildGoModule = buildGo124Module;
  inherit withRdpClient extPatches;
}
