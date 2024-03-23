{ lib
, rustPlatform
, fetchFromGitHub
}:
rustPlatform.buildRustPackage rec {
  pname = "typos-lsp";
  version = "0.1.15";

  src = fetchFromGitHub {
    owner = "tekumara";
    repo = "typos-lsp";
    rev = "refs/tags/v${version}";
    hash = "sha256-8mCK/NKik1zf6hqJN4pflDbtFALckHR/8AQborbOoHs=";
  };

  cargoHash = "sha256-aL7arYAiTpz9jy7Kh8u7OJmPMjayX4JiKoa7u8K0UiE=";

  # fix for compilation on aarch64
  # see https://github.com/NixOS/nixpkgs/issues/145726
  prePatch = ''
    rm .cargo/config.toml
  '';

  meta = with lib; {
    description = "Source code spell checker";
    homepage = "https://github.com/tekumara/typos-lsp";
    changelog = "https://github.com/tekumara/typos-lsp/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ tarantoj ];
    mainProgram = "typos-lsp";
  };
}
