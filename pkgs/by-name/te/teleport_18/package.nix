{
  buildTeleport,
  buildGo125Module,
  wasm-bindgen-cli_0_2_99,
  withRdpClient ? true,
  extPatches ? [ ],
}:

buildTeleport {
  version = "18.7.0";
  hash = "sha256-1AzIZ2jbYncpUStIrKgP6jhkJ42HDoXfhEv5hJdyDnA=";
  vendorHash = "sha256-p600z/Fm3y5KG8fDItIc/Xq4O0/DWHjcmrh5qJmCy1I=";
  pnpmHash = "sha256-/sLG0yfMIguj+yzr3bDj1AoPvDEva6ETjyKcqm4Fvks=";
  cargoHash = "sha256-SfVoh4HnHSOz1haPPV7a/RyA6LFjLRe78Mn2fVdVyEA=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_99;
  buildGoModule = buildGo125Module;
  inherit withRdpClient extPatches;
}
