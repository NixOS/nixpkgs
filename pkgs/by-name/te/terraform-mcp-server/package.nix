{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule (finalAttrs: {
  pname = "terraform-mcp-server";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "terraform-mcp-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rc+ojp4h++ctkjS/pew/p06lxWshrkOizkv63BLsmJQ=";
  };

  vendorHash = "sha256-lW5XIaY5NAn3sSDJExMd1i/dueb4p1Uc4Qpr4xsgmfE=";

  ldflags = [
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=${finalAttrs.src.rev}"
  ];

  subPackages = [ "cmd/terraform-mcp-server" ];

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
    maintainers = with lib.maintainers; [ connerohnesorge ];
    mainProgram = "terraform-mcp-server";
  };
})
