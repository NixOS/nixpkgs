{
  buildTeleport,
  buildGoModule,
  wasm-bindgen-cli_0_2_122,
  withRdpClient ? true,
  extPatches ? [ ],
}:

buildTeleport {
  version = "18.10.0";
  hash = "sha256-df2VEtMTsnB72WIQj7iButC3b/U7tpv2e6dQEZm5zVA=";
  vendorHash = "sha256-5uTZuWOSgL4319iUg8QuIqY4rACr4xBUHzdLXyG6Xo0=";
  pnpmHash = "sha256-Fvp2ROOcr7g0yqjQheiLTaBEMysmyLLyzir6pYh09SQ=";
  cargoHash = "sha256-cjks+Gv4CdlqWaJFFeyFsIuc3KsE7A/1MEDQB36pTkk=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_122;
  buildGoModule = buildGoModule;
  inherit withRdpClient extPatches;
}
