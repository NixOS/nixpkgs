{
  buildTeleport,
  buildGo125Module,
  wasm-bindgen-cli_0_2_99,
  withRdpClient ? true,
  extPatches ? [ ],
}:

buildTeleport {
  version = "18.7.2";
  hash = "sha256-1ANYBYNhTzSA3zhgUgKks73piHdw+4iXGFmGUWHTYpE=";
  vendorHash = "sha256-0HxDrsWWRjuaVGtbX7xwCMsj2dYRJr3wmpf8qInlyBE=";
  pnpmHash = "sha256-XJ2SLCMoFFeoBQ3YKIlq4APNOhSS8ipTNQufQ1nkYqs=";
  cargoHash = "sha256-SfVoh4HnHSOz1haPPV7a/RyA6LFjLRe78Mn2fVdVyEA=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_99;
  buildGoModule = buildGo125Module;
  inherit withRdpClient extPatches;
}
