{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
}:

buildGoModule (finalAttrs: {
  __structuredAttrs = true;

  pname = "tapioca";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "juacamole";
    repo = "tapioca";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NcDSk0N7r4UWTM+VhqulCmkXE6LfRvBFoNmwVufAaZU=";
  };

  vendorHash = "sha256-2Kqk4C+Ovy0wDSTVB/IHv+y3bDhCadontTP3GZ7a8/M=";

  # Installs under both names: Shopify's tapioca gem provides a `tapioca`
  # binary too, so upstream ships `tapio` for when that one wins PATH.

  nativeCheckInputs = [ git ];

  # The suite drives real git repositories and writes under $HOME.
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Agentic coding TUI for local and hosted LLMs";
    homepage = "https://github.com/juacamole/tapioca";
    changelog = "https://github.com/juacamole/tapioca/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "tapioca";
    maintainers = with lib.maintainers; [ juacamole ];
    platforms = lib.platforms.unix;
  };
})
