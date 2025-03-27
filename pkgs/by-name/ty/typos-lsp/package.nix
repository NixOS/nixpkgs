{ lib
, rustPlatform
, fetchFromGitHub
}:
rustPlatform.buildRustPackage rec {
  pname = "typos-lsp";
  # Please update the corresponding VSCode extension too.
  # See pkgs/applications/editors/vscode/extensions/tekumara.typos-vscode/default.nix
  version = "0.1.35";

  src = fetchFromGitHub {
    owner = "tekumara";
    repo = "typos-lsp";
    tag = "v${version}";
    hash = "sha256-5B4xWYJJ2KQLxzRQf0EKakGuB0LLOg023AIt8G3uAew=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Es/CdtyRtBghAeRoi5WrS0sdkm5flRlp3KXLs/nJ6UU=";

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
