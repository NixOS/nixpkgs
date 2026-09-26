{
  buildTeleport,
  buildGoModule,
  wasm-bindgen-cli_0_2_95,
  withRdpClient ? true,
  extPatches ? [ ],
}:

buildTeleport {
  version = "17.7.26";
  hash = "sha256-JwPW+w2ZS4jGWxf0GZgf3UMUrxKcIthnvZT8nImtE2c=";
  vendorHash = "sha256-YX0HC+cU3YpAdToALJa/FeCc8ANEq7E+zExzX42lk9c=";
  cargoHash = "sha256-BE/TBZoOaB3Th14E+t3qJ+0Uww56TtRA1sRQ+usFo+Y=";
  pnpmHash = "sha256-oVQF+Ba7zLCr86pPzFydVOBzA3GSzvtIfoggtiO2oFQ=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_95;
  inherit buildGoModule withRdpClient extPatches;
}
