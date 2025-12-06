{
  buildTeleport,
  buildGo124Module,
  wasm-bindgen-cli_0_2_99,
  withRdpClient ? true,
  extPatches ? [ ],
}:

buildTeleport {
  version = "18.4.2";
  hash = "sha256-hgebEtmxKOyL0GQACnwT++GUP68I3zf9GKYZ+JxXzt4=";
  vendorHash = "sha256-XOZwQJ/aW9+0X9KtcpQbVNYCOjwmlLHk9mg9LEVS+G0=";
  pnpmHash = "sha256-lwRNrprOb7YVkYRvXyWTyKNNQcm9XBrIeSsi75w4iNM=";
  cargoHash = "sha256-ia4We4IfIkqz82aFMVvXdzjDXw0w+OJSPVdutfau6PA=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_99;
  buildGoModule = buildGo124Module;
  inherit withRdpClient extPatches;
}
