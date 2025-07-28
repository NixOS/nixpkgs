{
  buildTeleport,
  buildGo123Module,
  wasm-bindgen-cli_0_2_95,
}:
buildTeleport rec {
  version = "16.5.14";
  hash = "sha256-24NVmJ97igUs45Ruuj9llRcHVsGMU1dtRm8f4R0pYG4=";
  vendorHash = "sha256-PDgrfol2zrmS8yzvJQoK486nl+akD9LP4Sh5IVz/jNE=";
  pnpmHash = "sha256-b6D7i68rX47+thleTeEfW+G72NxuqWNLmNXxJqe8ha8=";
  cargoHash = "sha256-04zykCcVTptEPGy35MIWG+tROKFzEepLBmn04mSbt7I=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_95;
  buildGoModule = buildGo123Module;
}
