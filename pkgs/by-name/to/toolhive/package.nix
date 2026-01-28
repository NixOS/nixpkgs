{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  testers,
  toolhive,
}:

buildGoModule (finalAttrs: {
  pname = "toolhive";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "stacklok";
    repo = "toolhive";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QdwkXegj8bXqR08VY2n5LC0TFxa02RjExgE2NJhy2zs=";
  };

  vendorHash = "sha256-p/PYSXZ4PdquMUPPXJUCqs2DRHrI03I05kulJz7Cyn8=";

  # Build only the main CLI and operator binaries
  subPackages = [
    "cmd/thv"
    "cmd/thv-operator"
  ];

  doCheck = true;

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      version = testers.testVersion {
        package = toolhive;
        command = "thv version";
        version = "ToolHive build-unknown";
      };
    };
  };

  meta = {
    description = "Run any MCP server — securely, instantly, anywhere";
    longDescription = ''
      ToolHive is an open-source tool for deploying Model Context Protocol (MCP)
      servers with a focus on security and ease of use. It provides a CLI to
      discover and deploy MCP servers, run servers in isolated containers,
      manage server configurations, and auto-configure clients like GitHub Copilot.
    '';
    homepage = "https://github.com/stacklok/toolhive";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ thrix ];
    mainProgram = "thv";
  };
})
