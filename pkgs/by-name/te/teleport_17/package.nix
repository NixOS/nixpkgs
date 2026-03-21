{
  buildTeleport,
  buildGoModule,
  wasm-bindgen-cli_0_2_95,
  withRdpClient ? true,
  extPatches ? [ ],
}:

buildTeleport {
  version = "17.7.19";
  hash = "sha256-2bQEW3HllZvMofumLSgvZvWqrlRV6fK9uB3QTJD6x3w=";
  vendorHash = "sha256-GUnX3TnHjZyqNsIDIy5Du6jRURWnYBsNb2zWEGl1tzQ=";
  cargoHash = "sha256-opLo7UmZzxrVxYZOwn4v4G5lhHFp5GrdOZe7uIb97q0=";
  pnpmHash = "sha256-mcv9Paybeu9RnNfzj1v0043UX2WhfgMpmWjVxQX7Fzc=";

  wasm-bindgen-cli = wasm-bindgen-cli_0_2_95;
  inherit buildGoModule withRdpClient extPatches;
}
