{ lib
, rustPlatform
, fetchFromGitHub
}:
rustPlatform.buildRustPackage rec {
  pname = "typos-lsp";
  version = "0.1.13";

  src = fetchFromGitHub {
    owner = "tekumara";
    repo = "typos-lsp";
    rev = "refs/tags/v${version}";
    hash = "sha256-2nNOUeuDDBi7Ak7ATKYyRqmGwebk0JqIdHN6GV+v+aA=";
  };

  cargoHash = "sha256-hQoxaavR4cefmpr+znXOs1OFJJ83mGk4TidFf13l7Ho=";

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
