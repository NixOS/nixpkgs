{
  buildTeleport,
  buildGoModule,
  wasm-bindgen-cli_0_2_95,
  withRdpClient ? true,
  extPatches ? [ ],
}:

buildTeleport {
  version = "17.7.16";
  hash = "sha256-xO1L4MRGf9OF+wm/9P5IccltO+zvijM8vP5JQwmqLSQ=";
  vendorHash = "sha256-BhQOvjSe8URmKWxKPemn/klgLoBFKfWXCYMp82QzaOE=";
  cargoHash = "sha256-EnIdf/3idwoQGJd6edQtWaXzVC1Gkwf8X2w2Zq80KGA=";
  pnpmHash = "sha256-0BOnrrzX33UncHPM6vc8UWP5GoU7xCDV9FGqBLVYTtM=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_95;
  inherit buildGoModule withRdpClient extPatches;
}
