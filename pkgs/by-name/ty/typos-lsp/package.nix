{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "typos-lsp";
  # Please update the corresponding VSCode extension too.
  # See pkgs/applications/editors/vscode/extensions/tekumara.typos-vscode/default.nix
<<<<<<< HEAD
  version = "0.1.46";
=======
  version = "0.1.45";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "tekumara";
    repo = "typos-lsp";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-cl9Ufoj+O0rmLIQ6iRYuF0xmziGdwtb9GeRWxM+9nP0=";
  };

  cargoHash = "sha256-PdLMAoezqmIb7RHU+5e8fnjY8ZO85aMJlznzzM2VWXA=";
=======
    hash = "sha256-Yyb2i3ymkxZGmyl3N7hcM2pWuJZRMxcWRNk283wdyy4=";
  };

  cargoHash = "sha256-FMKS49Uz7gwsXoa9VjVlMwUzZWUJ5D2kOYjQro9iNwE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # fix for compilation on aarch64
  # see https://github.com/NixOS/nixpkgs/issues/145726
  prePatch = ''
    rm .cargo/config.toml
  '';

<<<<<<< HEAD
  meta = {
    description = "Source code spell checker";
    homepage = "https://github.com/tekumara/typos-lsp";
    changelog = "https://github.com/tekumara/typos-lsp/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tarantoj ];
=======
  meta = with lib; {
    description = "Source code spell checker";
    homepage = "https://github.com/tekumara/typos-lsp";
    changelog = "https://github.com/tekumara/typos-lsp/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ tarantoj ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "typos-lsp";
  };
}
