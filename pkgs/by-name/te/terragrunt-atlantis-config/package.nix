{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "terragrunt-atlantis-config";
  version = "1.26.3";

  src = fetchFromGitHub {
    owner = "dbccompany";
    repo = "terragrunt-atlantis-config";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MR+r1FEF1805SggIanM8S9N0/L8YuU8OA9vW0S0ZfVg=";
  };

  vendorHash = "sha256-K+K0PhgD+TnyNt0LkTu8DhbFlsDwb6QDzq+GU6u3bhw=";

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
