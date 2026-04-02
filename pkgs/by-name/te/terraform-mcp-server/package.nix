{
  buildGoModule,
  fetchFromGitHub,
  lib,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "terraform-mcp-server";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "terraform-mcp-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V+TcIuw9SrSbqtjZMM5CSUjPof9xpdwN0NKGrU7M6kQ=";
  };

  vendorHash = "sha256-8bKDnnByc6tId7mWCaSxY9zgoBW7Ajlmd33xuMrJp1E=";

  ldflags = [
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=${finalAttrs.src.rev}"
  ];

  subPackages = [ "cmd/terraform-mcp-server" ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "Terraform Model Context Protocol (MCP) Server";
    longDescription = ''
      The Terraform MCP Server is a Go implementation of the Model Context
      Protocol (MCP) server that provides seamless integration with Terraform
      Registry APIs, enabling advanced automation and interaction capabilities
      for developers and tools.

      This server allows LLMs to interact with Terraform modules, providers,
      and other Terraform Registry features through structured API interactions.
    '';
    homepage = "https://github.com/hashicorp/terraform-mcp-server";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      connerohnesorge
      pilz
    ];
    mainProgram = "terraform-mcp-server";
  };
})
