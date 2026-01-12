{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  alsa-lib,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ting";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "dhth";
    repo = "ting";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k6TJ9/YtsjNNYPj8YUGCfaQaVwXHoUQG4muOvrkN34A=";
  };

  cargoHash = "sha256-yDSOXvRRBIDYhggj1SwAHxI3jv+xAs2LTUmUqPxCk00=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ alsa-lib ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Audio feedback on the command line";
    homepage = "https://github.com/dhth/ting";
    changelog = "https://github.com/dhth/ting/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "ting";
    platforms = lib.platforms.linux;
  };
})
