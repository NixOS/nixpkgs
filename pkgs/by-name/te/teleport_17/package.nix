{
  buildTeleport,
  buildGoModule,
  wasm-bindgen-cli_0_2_95,
}:

buildTeleport rec {
  version = "17.7.4";
  hash = "sha256-n64aa3Cga6svlchRXqlFRg7CLCw0pJV+EJUQbbjgtuM=";
  vendorHash = "sha256-7Rb94ERtp3H1Jwyh9d7AFT06d4xXdnfe5tpdvJQrbUQ=";
  cargoHash = "sha256-qz8gkooQTuBlPWC4lHtvBQpKkd+nEZ0Hl7AVg9JkPqs=";
  pnpmHash = "sha256-A8EIK+6aVq/vtfRYxs0jPHdFlv65lMn4FdyvLeoXozA=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_95;
  inherit buildGoModule;
}
