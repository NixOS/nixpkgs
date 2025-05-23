{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  go-mockery,
  mockgen,
}:

buildGoModule (finalAttrs: {
  pname = "terragrunt";
  version = "0.80.2";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = "terragrunt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FgytHWKtXK0tNDFOVOEciEzyVEXLbk9T2Nk8Se35HnY=";
  };

  nativeBuildInputs = [
    versionCheckHook
    go-mockery
    mockgen
  ];

  preBuild = ''
    make generate-mocks
  '';

  vendorHash = "sha256-Zgoon6eMUXn2zaxHfJovtWV9Q11rDdkBrYzNqa73DsM=";

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
