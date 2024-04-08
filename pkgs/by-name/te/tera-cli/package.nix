{
  lib,
  fetchFromGitHub,
  rustPlatform
}:
rustPlatform.buildRustPackage rec {
  pname = "tera-cli";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "chevdor";
    repo = "tera-cli";
    rev = "v${version}";
    hash = "sha256-Fzrlt6p4bVtJvGg8SaMdS/+2wzABtBkj9ERcg3/bwcQ=";
  };

  cargoHash = "sha256-aPN7rbU/BSgNAoq0g8JrzsXk3pbenrJZxqrm5f4zYn8=";

  meta = with lib; {
    description = "A command line utility to render templates from json|toml|yaml and ENV, using the tera templating engine";
    homepage = "https://github.com/chevdor/tera-cli";
    license = licenses.mit;
    maintainers = with maintainers; [_365tuwe];
    mainProgram = "tera";
    platforms = platforms.linux;
  };
}
