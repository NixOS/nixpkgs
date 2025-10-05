{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "typos-lsp";
  # Please update the corresponding VSCode extension too.
  # See pkgs/applications/editors/vscode/extensions/tekumara.typos-vscode/default.nix
  version = "0.1.44";

  src = fetchFromGitHub {
    owner = "tekumara";
    repo = "typos-lsp";
    tag = "v${version}";
    hash = "sha256-8UEMcb1yN3haI4OZwl2GRIF6v6t5BoDipxd9167sa7E=";
  };

  cargoHash = "sha256-LZdzgqeA7Xld8Ts4efafWPX53m9YfvqagSpOMfXml/E=";

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
