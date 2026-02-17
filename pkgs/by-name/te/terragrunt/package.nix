{
  lib,
  buildGo125Module,
  fetchFromGitHub,
  versionCheckHook,
  mockgen,
}:
buildGo125Module (finalAttrs: {
  pname = "terragrunt";
  version = "0.97.0";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = "terragrunt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LJGc85oCDEW/z9I4Mcr9Pyv9MLqqN4Zu/nJK1LTD9mk=";
  };

  nativeBuildInputs = [
    mockgen
  ];

  proxyVendor = true;

  preBuild = ''
    make generate-mocks
  '';

  vendorHash = "sha256-BXFtw7+f9Isnk6EB3U4eLlho5B3rTnofmWBDbbbroUs=";

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
