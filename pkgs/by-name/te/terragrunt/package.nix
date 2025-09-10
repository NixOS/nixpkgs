{
  lib,
  buildGo125Module,
  fetchFromGitHub,
  versionCheckHook,
  mockgen,
}:
buildGo125Module (finalAttrs: {
  pname = "terragrunt";
  version = "0.86.0";

  src = fetchFromGitHub {
    owner = "gruntwork-io";
    repo = "terragrunt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Xmka1391wEGufEEavQNoB5YuzR7npe6ky8MzKJnGQt8=";
  };

  nativeBuildInputs = [
    versionCheckHook
    mockgen
  ];

  preBuild = ''
    make generate-mocks
  '';

  vendorHash = "sha256-aQzt7yeNoL1OF+mO6y2axeiuJbfuMBzoEAm0+Y9+Xr8=";

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
