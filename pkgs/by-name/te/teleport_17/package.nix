{
  buildTeleport,
  buildGoModule,
  wasm-bindgen-cli_0_2_95,
  withRdpClient ? true,
  extPatches ? [ ],
}:

buildTeleport {
  version = "17.7.20";
  hash = "sha256-zxP7vhDyxypotG58wzwlCx8JMoRSYC0adMe+zKfrOek=";
  vendorHash = "sha256-uwSCPu3z9LCvN/vKJg/Q9rgk6wnjh4P4tq4a5suPNrg=";
  cargoHash = "sha256-opLo7UmZzxrVxYZOwn4v4G5lhHFp5GrdOZe7uIb97q0=";
  pnpmHash = "sha256-quHu43JccCpguSeHkGnpqL81oDN4p5WtAt/sOgMCCec=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_95;
  inherit buildGoModule withRdpClient extPatches;
}
