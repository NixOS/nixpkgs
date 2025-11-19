{
  buildTeleport,
  buildGoModule,
  wasm-bindgen-cli_0_2_95,
  withRdpClient ? true,
  extPatches ? [ ],
}:

buildTeleport {
  version = "17.7.10";
  hash = "sha256-H87aP8PyPcd2J42+frQBMgd+OAjQwhIF+/Cw4G9xXSg=";
  vendorHash = "sha256-rk8KTrMQNvkT8j8RVlKEVJ8Ke10DlQJlZaDJmZLFuEY=";
  cargoHash = "sha256-qz8gkooQTuBlPWC4lHtvBQpKkd+nEZ0Hl7AVg9JkPqs=";
  pnpmHash = "sha256-Be/XoaA4oM7kTup02bE7GcmMzjtuIXuJcZkK23XT/mQ=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_95;
  inherit buildGoModule withRdpClient extPatches;
}
