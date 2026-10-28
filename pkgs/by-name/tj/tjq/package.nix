{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tjq";
  version = "0.0.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "alpaylan";
    repo = "tjq";
    tag = "v${finalAttrs.version}";
    hash = "sha256-O2Uell85xd9+WJYgB7zEI3mPxaAcUlsoXh6UGvTXZhs=";
  };

  cargoHash = "sha256-T6wuYWv6l8w5rRtdWs0DWi61j8aDbXMwtv9nQvlC7CM=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Giving types to jq";
    homepage = "https://github.com/alpaylan/tjq";
    changelog = "https://github.com/alpaylan/tjq/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    mainProgram = "tjq";
  };
})
