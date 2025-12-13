{
  lib,
  buildGo125Module,
  fetchFromGitHub,
  versionCheckHook,
  mockgen,
}:
buildGo125Module (finalAttrs: {
  pname = "terragrunt";
  version = "0.94.0";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = "terragrunt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-agc7tciz9ciz2gFjGsmafc46MgenOAQDyByJN9X4Wm4=";
  };

  nativeBuildInputs = [
    versionCheckHook
    mockgen
  ];

  preBuild = ''
    make generate-mocks
  '';

  vendorHash = "sha256-DkFqj52mdkJvjG5yceRH5GEKWHU73rOE6dJno/6N2k8=";

  doCheck = false;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/gruntwork-io/go-commons/version.Version=v${finalAttrs.version}"
    "-extldflags '-static'"
  ];

  doInstallCheck = true;

  meta = {
    homepage = "https://terragrunt.gruntwork.io";
    changelog = "https://github.com/gruntwork-io/terragrunt/releases/tag/v${finalAttrs.version}";
    description = "Thin wrapper for Terraform that supports locking for Terraform state and enforces best practices";
    mainProgram = "terragrunt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jk
      qjoly
      kashw2
    ];
  };
})
