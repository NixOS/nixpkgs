{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "terminal-toys";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "Seebass22";
    repo = "terminal-toys";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G4UfX1B4TM4w5KQreCXIZh91o0Tvezhz0ZxojyXRtX8=";
  };

  cargoHash = "sha256-hjWPWNwZxJkuoFuEUuf7SOSJ4CEtqwCOV5ZM7CGtvfY=";

  meta = {
    description = "Screensavers for your terminal";
    homepage = "https://github.com/Seebass22/terminal-toys";
    changelog = "https://github.com/Seebass22/terminal-toys/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "terminal-toys";
  };
})
