{
  lib,
  rustPlatform,
  fetchFromGitea,
}:
rustPlatform.buildRustPackage rec {
  pname = "xdg-terminal-exec-mkhl";
  version = "0.2.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "mkhl";
    repo = "xdg-terminal-exec";
    rev = "v${version}";
    hash = "sha256-iVp+tg+OujMMddKsQ/T9wyqh/Jk/j/jQgsl23uQA/iM=";
  };

  cargoHash = "sha256-4GNdH+cfr3hhbK3BQXHntPr0sTSl6SS56wkdTWbv8/k=";

  meta = {
    description = "Alternative rust-based implementation of the proposed XDG Default Terminal Execution Specification";
    license = lib.licenses.gpl3Plus;
    mainProgram = "xdg-terminal-exec";
    maintainers = with lib.maintainers; [ quantenzitrone ];
    platforms = lib.platforms.unix;
  };
}
