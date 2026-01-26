{
  buildTeleport,
  buildGoModule,
  wasm-bindgen-cli_0_2_95,
  withRdpClient ? true,
  extPatches ? [ ],
}:

buildTeleport {
  version = "17.7.14";
  hash = "sha256-k8ZleEYaH1Zh4go8QQPbfoAn1fD/YaHfk6Q671pQlIM=";
  vendorHash = "sha256-GTv4nb4wfVfcfjnK0dawJIAP0eSzIWibawqygUSzDxc=";
  cargoHash = "sha256-EnIdf/3idwoQGJd6edQtWaXzVC1Gkwf8X2w2Zq80KGA=";
  pnpmHash = "sha256-bublGuaTIOh0YdYIgSFfnE3E16sn4ktNCGPXoRIxxHY=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_95;
  inherit buildGoModule withRdpClient extPatches;
}
