{
  buildTeleport,
  buildGoModule,
  wasm-bindgen-cli_0_2_95,
  withRdpClient ? true,
  extPatches ? [ ],
}:
buildTeleport {
  version = "16.5.15";
  hash = "sha256-DqNG6gl+KdjSbkE9Bwum8az8cLCSOmZwo9xpuWafHCA=";
  vendorHash = "sha256-sZvRKLF2iZ3UpgGNUPuWMT7VTpnDa2uU0d1XjDKSmdo=";
  pnpmHash = "sha256-8xnH9PkKz77whtq/LVYUjyG1Z1reRtW03Gv8sZ/1vww=";
  cargoHash = "sha256-04zykCcVTptEPGy35MIWG+tROKFzEepLBmn04mSbt7I=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_95;
  inherit buildGoModule withRdpClient extPatches;
}
