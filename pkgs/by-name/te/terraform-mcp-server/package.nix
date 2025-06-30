{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
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

  doCheck = false;

  vendorHash = "sha256-m4J2WGcL0KB1InyciQEmLOSBw779/kagUOIkTwc4CE4=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Seamless integration with Terraform ecosystem, enabling advanced automation and interaction capabilities for Infrastructure as Code (IaC) development";
    homepage = "https://github.com/hashicorp/terraform-mcp-server";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ pilz ];
    mainProgram = "terraform-mcp-server";
  };
})
