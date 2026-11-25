{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "terragrunt-atlantis-config";
  version = "1.26.2";

  src = fetchFromGitHub {
    owner = "dbccompany";
    repo = "terragrunt-atlantis-config";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QbjofmCsKd2C1+4z5oXnK5jpD0kBafeJdPo24/HTTCs=";
  };

  vendorHash = "sha256-VbrzyUaLwj0tvCdH/DZYX+fL7epZI+rv9fOBYGVNho8=";

  env.CGO_ENABLED = 0;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  doCheck = false; # requires network access

  ldflags = [
    "-X main.VERSION=${finalAttrs.version}"
  ];

  __structuredAttrs = true;

  meta = {
    homepage = "https://github.com/dbccompany/terragrunt-atlantis-config";
    changelog = "https://github.com/dbccompany/terragrunt-atlantis-config/releases/tag/v${finalAttrs.version}";
    description = "Generate Atlantis Config for Terragrunt projects";
    mainProgram = "terragrunt-atlantis-config";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      yethal
    ];
  };
})
