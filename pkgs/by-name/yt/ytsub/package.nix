{
  lib,
  fetchFromGitHub,
  rustPlatform,
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ytsub";
  version = "0.10.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sarowish";
    repo = "ytsub";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CrYRQ+0WJ6VDG+Y4J0Wk22wcNb+0SxhRbzPJRXQNTjs=";
  };

  cargoHash = "sha256-8p2//37ATU9d3kMq0tM6Pr+wqbrfOh8Z4fxgwhU4rpA=";

  buildInputs = [ sqlite ];

  meta = {
    description = "Subscriptions only TUI Youtube client";
    homepage = "https://github.com/sarowish/ytsub";
    changelog = "https://github.com/sarowish/ytsub/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sarowish ];
    mainProgram = "ytsub";
  };
})
