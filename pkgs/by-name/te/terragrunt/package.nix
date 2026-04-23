{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  mockgen,
}:
buildGoModule (finalAttrs: {
  pname = "terragrunt";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = "terragrunt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rT/GsWEezekWinBj2Wp5smCrf99VBUw8Yw3S+VpwfTQ=";
  };

  nativeBuildInputs = [
    mockgen
  ];

  proxyVendor = true;

  preBuild = ''
    make generate-mocks
  '';

  vendorHash = "sha256-+UtLq5EwUeB4GH324tYV3jqArpdvX98UP7WZSTlgZwU=";

  excludedPackages = [ "test/flake" ];

  doCheck = false;

  ldflags = [
    "-s"
    "-X github.com/gruntwork-io/go-commons/version.Version=v${finalAttrs.version}"
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
