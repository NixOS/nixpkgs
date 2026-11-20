{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  nix-update-script,
  testers,
}:

buildGo127Module (finalAttrs: {
  pname = "toolhive";
  version = "0.67.0";

  src = fetchFromGitHub {
    owner = "stacklok";
    repo = "toolhive";
    tag = "v${finalAttrs.version}";
    hash = "sha256-i9fqsdlTE2rzXFvdwA8mDkk9LvdG80xQCN1tsbKxk1w=";
  };

  vendorHash = "sha256-cQmGWythKkXAlxVuHs9DBftoiu5vI3wfg1DwQ3gL0bU=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/stacklok/toolhive/pkg/versions.Version=v${finalAttrs.version}"
  ];

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
        package = finalAttrs.finalPackage;
        command = "thv version";
        version = "ToolHive v${finalAttrs.version}";
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
