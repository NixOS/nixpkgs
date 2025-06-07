{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "terraform-mcp-server";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "terraform-mcp-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HYiA0Mfp87czQShiXbS+y20yQzxTn0+hfM0M1kLFZFM=";
  };

  # remove the end-to-end tests because it would require docker
  # https://github.com/hashicorp/terraform-mcp-server/tree/main/e2e
  postPatch = ''
    rm -rf ./e2e
    sed -i '/^test-e2e:/,/^\t.*e2e$/d' Makefile
  '';

  vendorHash = "sha256-QQjzJJhF50K6DuYWSobt/WX2g02xWOVzc/MoE876xTw=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Seamless integration with Terraform ecosystem, enabling advanced automation and interaction capabilities for Infrastructure as Code (IaC) development";
    homepage = "https://github.com/hashicorp/terraform-mcp-server";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ pilz ];
    mainProgram = "terraform-mcp-server";
  };
})
