{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "terraform-mcp-server";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "terraform-mcp-server";
    rev = "v${version}";
    hash = "sha256-HYiA0Mfp87czQShiXbS+y20yQzxTn0+hfM0M1kLFZFM=";
  };

  vendorHash = "sha256-m4J2WGcL0KB1InyciQEmLOSBw779/kagUOIkTwc4CE4=";

  ldflags = [
    "-X main.version=${version}"
    "-X main.commit=${src.rev}"
  ];

  subPackages = [ "cmd/terraform-mcp-server" ];

  postInstall = ''
    mkdir -p $out/share/${pname}

    cp README.md LICENSE $out/share/${pname}/ || true
  '';

  meta = with lib; {
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
    license = licenses.mpl20;
    maintainers = with maintainers; [ connerohnesorge ];
    mainProgram = "terraform-mcp-server";
  };
}
