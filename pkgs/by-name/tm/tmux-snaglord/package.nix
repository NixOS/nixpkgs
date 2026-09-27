{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tmux-snaglord";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "raine";
    repo = "tmux-snaglord";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kWlGvUmYBXbHnVohyWxV9oW5FCXd0HgdD/E9wlHfI4A=";
  };

  cargoHash = "sha256-QtW83eJ7B63rbgoZAbdmdMLlWm27uT4GfoFo7leFV20=";

  meta = {
    description = "turn your tmux scrollback into a structured, searchable list of commands and their outputs";
    homepage = "https://github.com/raine/tmux-snaglord";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      bbigras
    ];
    mainProgram = "tmux-snaglord";
  };
})
