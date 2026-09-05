{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "terragrunt-atlantis-config";
  version = "1.21.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "transcend-io";
    repo = "terragrunt-atlantis-config";
    rev = "v${finalAttrs.version}";
    hash = "sha256-lh5c5+Lj2jb9BrM3piG9ERUjluiN0f/sPYp4OyKzYBw=";
  };

  vendorHash = "sha256-brTFOsO2tgWlli1z0W0DGh7114iSlTMHlSZWoFmGdAs=";

  ldflags = [
    "-s"
    "-w"
  ];

  preCheck = ''
    mkdir -p cmd/test_artifacts
  '';

  meta = {
    changelog = "https://github.com/transcend-io/terragrunt-atlantis-config/releases/tag/v${finalAttrs.version}";
    description = "Generate Atlantis config for Terragrunt projects";
    homepage = "https://github.com/transcend-io/terragrunt-atlantis-config";
    license = lib.licenses.mit;
    mainProgram = "terragrunt-atlantis-config";
    maintainers = with lib.maintainers; [ benley ];
  };
})
