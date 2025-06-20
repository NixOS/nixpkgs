{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  mockgen,
}:

buildGoModule (finalAttrs: {
  pname = "terragrunt";
  version = "0.81.8";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = "terragrunt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+f6rHS1ljj59wmR3NJwviJEBqeS6VzoMPfal4MuoyUE=";
  };

  nativeBuildInputs = [
    versionCheckHook
    mockgen
  ];

  preBuild = ''
    make generate-mocks
  '';

  vendorHash = "sha256-A8P0wJ/EUTnAeCIFfAECTBQmSaOcED6SDbeRnnTlcJ8=";

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
