{ lib
, rustPlatform
, fetchFromGitHub
}:
rustPlatform.buildRustPackage rec {
  pname = "typos-lsp";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "tekumara";
    repo = "typos-lsp";
    rev = "refs/tags/v${version}";
    hash = "sha256-LzemgHVCuLkLaJyyrJhIsOOn+OnYuiJsMSxITNz6R8g=";
  };

  cargoHash = "sha256-LFRg/Y/nudrdPw/o3WUH6aM+ThE8N/HII5J0Ikid8GI=";

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
