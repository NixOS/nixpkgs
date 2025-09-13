{
  buildTeleport,
  buildGoModule,
  wasm-bindgen-cli_0_2_95,
  withRdpClient ? true,
  extPatches ? [ ],
}:

buildTeleport {
  version = "17.7.5";
  hash = "sha256-9Qtp/lTbG7xLk9mzHwwMAQkt08oPRM1FP+NLSXEr8Mo=";
  vendorHash = "sha256-4n1N9yiC2ILd8X8ntSPd2JhqRHROKoYK/S0GphVo+bI=";
  cargoHash = "sha256-qz8gkooQTuBlPWC4lHtvBQpKkd+nEZ0Hl7AVg9JkPqs=";
  pnpmHash = "sha256-ovtcJWeRFQUfzbanGXzOcZk/0KwKiZYrr3VmqMt+nfE=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_95;
  inherit buildGoModule withRdpClient extPatches;
}
