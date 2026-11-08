{
  lib,
  buildGo127Module,
  fetchFromGitHub,
  nix-update-script,
  testers,
}:

buildGo127Module (finalAttrs: {
  pname = "toolhive";
  version = "0.63.0";

  src = fetchFromGitHub {
    owner = "stacklok";
    repo = "toolhive";
    tag = "v${finalAttrs.version}";
    hash = "sha256-syNFrwlADQTe5mUJjqhcK8BpVqVLsL5jFYdZ+L/F4X4=";
  };

  vendorHash = "sha256-L0xjX6MPsLXFukXFPJE7Nj6YoSmJi7K5vjnSdwSU3YI=";

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
