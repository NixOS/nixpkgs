{
  buildTeleport,
  buildGoModule,
  wasm-bindgen-cli_0_2_95,
  withRdpClient ? true,
  extPatches ? [ ],
}:

buildTeleport {
  version = "17.7.9";
  hash = "sha256-qS0QWSbhyhBEJTEcJGEbomhsH4hkcLYJlvsaQeBIH7A=";
  vendorHash = "sha256-ZxJPzqvSGjc4AS5CPuSKCLWVvqcpqlMUUMtSqWn37o0=";
  cargoHash = "sha256-qz8gkooQTuBlPWC4lHtvBQpKkd+nEZ0Hl7AVg9JkPqs=";
  pnpmHash = "sha256-+240TF1+wHw2HIt4GrhnknL3yxLqQbO+atNUkf/vh6Q=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_95;
  inherit buildGoModule withRdpClient extPatches;
}
