{
  buildTeleport,
  buildGo125Module,
  wasm-bindgen-cli_0_2_99,
  withRdpClient ? true,
  extPatches ? [ ],
}:

buildTeleport {
  version = "18.7.6";
  hash = "sha256-p7qwsUr6n6OAl/b20SgropAubfPfwBiVTvbReb2HpO8=";
  vendorHash = "sha256-/ZY0J0yB/8qMG6vEIta7Nf2Uv3xTZ/WPoMz+Dj5hwZA=";
  pnpmHash = "sha256-uRsS5m0Q4fAFvJ3Qp6xcEAB8QFriLXbeGtD0o0n46RE=";
  cargoHash = "sha256-KkFwMSBXsRmDuaPU1n6FPq2P5UQiQnb7+HEDOhhmjd0=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_99;
  buildGoModule = buildGo125Module;
  inherit withRdpClient extPatches;
}
