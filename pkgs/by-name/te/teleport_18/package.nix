{
  buildTeleport,
  buildGo125Module,
  wasm-bindgen-cli_0_2_99,
  withRdpClient ? true,
  extPatches ? [ ],
}:

buildTeleport {
  version = "18.9.1";
  hash = "sha256-FIPExc8tMoPXfWc7pQjwQRkxmiQEOxdkYgWS0GejQuk=";
  vendorHash = "sha256-BlQhypAoK85ID0pgmXbUboks88qjSg3p5E8qxyTIc9M=";
  pnpmHash = "sha256-ZGbuBMPwC3u/2qDTVLH2InOGVc94Vq0i3AKHMsOwq3k=";
  cargoHash = "sha256-KbmacTEOElmboHMK6YxWGC0brlDsX7kcvpaOOZmuops=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_99;
  buildGoModule = buildGo125Module;
  inherit withRdpClient extPatches;
}
