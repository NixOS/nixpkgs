{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "typos-lsp";
  # Please update the corresponding VSCode extension too.
  # See pkgs/applications/editors/vscode/extensions/tekumara.typos-vscode/default.nix
  version = "0.1.46";

  src = fetchFromGitHub {
    owner = "tekumara";
    repo = "typos-lsp";
    tag = "v${version}";
    hash = "sha256-cl9Ufoj+O0rmLIQ6iRYuF0xmziGdwtb9GeRWxM+9nP0=";
  };

  cargoHash = "sha256-PdLMAoezqmIb7RHU+5e8fnjY8ZO85aMJlznzzM2VWXA=";

  # fix for compilation on aarch64
  # see https://github.com/NixOS/nixpkgs/issues/145726
  prePatch = ''
    rm .cargo/config.toml
  '';

  meta = {
    description = "Source code spell checker";
    homepage = "https://github.com/tekumara/typos-lsp";
    changelog = "https://github.com/tekumara/typos-lsp/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tarantoj ];
    mainProgram = "typos-lsp";
  };
}
