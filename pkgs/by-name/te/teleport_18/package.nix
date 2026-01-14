{
  buildTeleport,
  buildGo124Module,
  wasm-bindgen-cli_0_2_99,
  withRdpClient ? true,
  extPatches ? [ ],
}:

buildTeleport {
  version = "18.6.1";
  hash = "sha256-Jtjy2qmlm7zsl0a8o4/4jWdnse1yFR++oq3FcDuQOJo=";
  vendorHash = "sha256-PW8UP1YuUssw//1qb3oUN/FrbLUwt6D+c4q6jrm09Xk=";
  pnpmHash = "sha256-xjAqyReWRdty67LWaNX1jG4/uCeQtUMH/BKLIHUx6+0=";
  cargoHash = "sha256-ia4We4IfIkqz82aFMVvXdzjDXw0w+OJSPVdutfau6PA=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_99;
  buildGoModule = buildGo124Module;
  inherit withRdpClient extPatches;
}
