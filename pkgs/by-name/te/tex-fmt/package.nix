{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "tex-fmt";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "WGUNDERWOOD";
    repo = "tex-fmt";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ii/z9ZmsWCHxxqUbkcu7HRBuN2LiLCxzUvqRexwQ/Co=";
  };

  cargoHash = "sha256-2vPxsXKInH18h/AoOWfl0VteUBmxWDzZa6AtpKfY5Hs=";

  meta = {
    description = "LaTeX formatter written in Rust";
    homepage = "https://github.com/WGUNDERWOOD/tex-fmt";
    license = lib.licenses.mit;
    mainProgram = "tex-fmt";
    maintainers = with lib.maintainers; [ wgunderwood ];
  };
}
