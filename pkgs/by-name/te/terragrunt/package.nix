{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  mockgen,
}:
buildGoModule (finalAttrs: {
  pname = "terragrunt";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = "terragrunt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LK6WMYcOfQR5Qp7ivkx5A3hpsU+r5VrxIg+1Gum+Kxw=";
  };

  nativeBuildInputs = [
    mockgen
  ];

  proxyVendor = true;

  preBuild = ''
    make generate-mocks
  '';

  vendorHash = "sha256-ilgZ8rzYtaol7q5qNSiA81oBMnpdckNtlYfvmT7ZOcM=";

  excludedPackages = [ "test/flake" ];

  doCheck = false;

  ldflags = [
    "-s"
    "-X github.com/gruntwork-io/terragrunt/internal/version.Version=v${finalAttrs.version}"
    "-extldflags '-static'"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
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
