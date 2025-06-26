{
  lib,
  buildGo124Module,
  fetchFromGitHub,
  testers,
  toolhive,
}:

buildGo124Module rec {
  pname = "toolhive";
  version = "0.0.47";

  src = fetchFromGitHub {
    owner = "stacklok";
    repo = "toolhive";
    rev = "refs/tags/v${version}";
    hash = "sha256-FXJUEEyCw7ChuzmSAzwXd2LoJXT6vpH+j3muXx5TjPI=";
  };

  vendorHash = "sha256-aP923ezK4/2zTaU9QQLUmNN6KIddOaTlpsYMT2flRaE=";

  # Allow Go version override
  allowGoReference = false;

  # Build only the main CLI and operator binaries
  subPackages = [
    "cmd/thv"
    "cmd/thv-operator"
  ];

  # Enable tests and sandbox
  doCheck = true;

  passthru.tests = {
    version = testers.testVersion {
      package = toolhive;
      command = "thv version";
      version = "ToolHive build-unknown";
    };
  };

  meta = with lib; {
    description = "Run any MCP server — securely, instantly, anywhere";
    longDescription = ''
      ToolHive is an open-source tool for deploying Model Context Protocol (MCP)
      servers with a focus on security and ease of use. It provides a CLI to
      discover and deploy MCP servers, run servers in isolated containers,
      manage server configurations, and auto-configure clients like GitHub Copilot.
    '';
    homepage = "https://github.com/stacklok/toolhive";
    license = licenses.asl20;
    maintainers = with maintainers; [ thrix ];
    mainProgram = "thv";
  };
}
