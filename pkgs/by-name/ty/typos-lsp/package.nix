{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "typos-lsp";
  # Please update the corresponding VSCode extension too.
  # See pkgs/applications/editors/vscode/extensions/tekumara.typos-vscode/default.nix
  version = "0.1.58";

  src = fetchFromGitHub {
    owner = "tekumara";
    repo = "typos-lsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Pi3jJmhZDQCb7LUYK35BlrdxmViJiman6TEhCC4jRRk=";
  };

  cargoHash = "sha256-9j8HQJejdX5OaRRcRuCkbwGmbEUoa1B7gWD+X+PshsQ=";

  # fix for compilation on aarch64
  # see https://github.com/NixOS/nixpkgs/issues/145726
  prePatch = ''
    rm .cargo/config.toml
  '';

  meta = {
    description = "Source code spell checker";
    homepage = "https://github.com/tekumara/typos-lsp";
    changelog = "https://github.com/tekumara/typos-lsp/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tarantoj ];
    mainProgram = "typos-lsp";
  };
})
