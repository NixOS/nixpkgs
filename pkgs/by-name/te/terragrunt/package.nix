{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  mockgen,
}:

buildGoModule (finalAttrs: {
  pname = "terragrunt";
  version = "0.82.3";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = "terragrunt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qDzqJRjRcK0CIn1ARL+InnPtzRIqN/AIxPLE+J9pE1k=";
  };

  nativeBuildInputs = [
    versionCheckHook
    mockgen
  ];

  preBuild = ''
    make generate-mocks
  '';

  vendorHash = "sha256-d8h/mdcqnL7wkg+ZqWt2ywSLD37Oddb8ub59XGEmSWk=";

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
