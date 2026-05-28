{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zellij-cb";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "ndavd";
    repo = "zellij-cb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6TZyC5Ib1FbN2JTcPM1zYnAWb+cQZoWPIW7Sh+VYxiI=";
  };

  cargoHash = "sha256-F68Cgyu8+HuxdPOzBBhemc16AYpn+3hRR5XU07C02AY=";

  meta = {
    description = "Customizable compact bar plugin for Zellij";
    homepage = "https://github.com/ndavd/zellij-cb";
    changelog = "https://github.com/ndavd/zellij-cb/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
  };
})
