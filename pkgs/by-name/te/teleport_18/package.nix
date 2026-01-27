{
  buildTeleport,
  buildGo124Module,
  wasm-bindgen-cli_0_2_99,
  withRdpClient ? true,
  extPatches ? [ ],
}:

buildTeleport {
  version = "18.6.4";
  hash = "sha256-Xn7Wl9xcp+3vRY5J12uX/EGc7Mck4cX+D0iR5aTujIE=";
  vendorHash = "sha256-PW8UP1YuUssw//1qb3oUN/FrbLUwt6D+c4q6jrm09Xk=";
  pnpmHash = "sha256-WlQSD5UZ5WHFcPwgYFs+I2F0LfH5Zg3SFrps0IkpZkE=";
  cargoHash = "sha256-tp+xxa+sYQpvgD2Yv/W0hegRpUubBeFpdngRyByNxJc=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_99;
  buildGoModule = buildGo124Module;
  inherit withRdpClient extPatches;
}
