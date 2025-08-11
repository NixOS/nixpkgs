{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
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

  doCheck = false;

  vendorHash = "sha256-lW5XIaY5NAn3sSDJExMd1i/dueb4p1Uc4Qpr4xsgmfE=";

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
