{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "tex-fmt";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "WGUNDERWOOD";
    repo = "tex-fmt";
    rev = "refs/tags/v${version}";
    hash = "sha256-jVrd3yZ07+ppsdt+8sNKX1rdmU+UiRCyx80EMXdoK54=";
  };

  cargoHash = "sha256-XQ1oEF+axp8pC6OkLlab1qI7RJeAyeSb58oChgaaS1s=";

  meta = {
    description = "LaTeX formatter written in Rust";
    homepage = "https://github.com/WGUNDERWOOD/tex-fmt";
    license = lib.licenses.mit;
    mainProgram = "tex-fmt";
    maintainers = with lib.maintainers; [ wgunderwood ];
  };
}
