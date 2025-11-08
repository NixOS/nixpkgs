{
  lib,
  buildGo125Module,
  fetchFromGitHub,
  versionCheckHook,
  mockgen,
}:
buildGo125Module (finalAttrs: {
  pname = "terragrunt";
  version = "0.93.0";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = "terragrunt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wi5Ff2wYPMgMMHZAJlq1v/UHjnRyNFbAy3IUYA+T5yI=";
  };

  nativeBuildInputs = [
    versionCheckHook
    mockgen
  ];

  preBuild = ''
    make generate-mocks
  '';

  vendorHash = "sha256-GLdUM5vlLO6B8ZCGiBAz5L32Wzr9eeYZxPtUc9MkjhE=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/gruntwork-io/go-commons/version.Version=v${finalAttrs.version}"
    "-extldflags '-static'"
  ];

  doInstallCheck = true;

  meta = with lib; {
    homepage = "https://terragrunt.gruntwork.io";
    changelog = "https://github.com/gruntwork-io/terragrunt/releases/tag/v${finalAttrs.version}";
    description = "Thin wrapper for Terraform that supports locking for Terraform state and enforces best practices";
    mainProgram = "terragrunt";
    license = licenses.mit;
    maintainers = with maintainers; [
      jk
      qjoly
      kashw2
    ];
  };
})
