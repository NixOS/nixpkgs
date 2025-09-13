{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tu";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "ad-si";
    repo = "tu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ai3jzM5tAVc8goD188MPgtxPlrF3zOuvfNzGHSu5t4A=";
  };

  cargoHash = "sha256-tZilaezZfpIrN/aU/hN1i7lgeI98U/H9rgEny8PthY0=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI tool to convert a natural language date/time string to UTC";
    homepage = "https://github.com/ad-si/tu";
    changelog = "https://github.com/ad-si/tu/blob/${finalAttrs.src.tag}/changelog.md";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "tu";
  };
})
