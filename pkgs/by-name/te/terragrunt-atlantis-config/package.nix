{
  lib,
  buildGo125Module,
  fetchFromGitHub,
  versionCheckHook,
}:
buildGo125Module (finalAttrs: {
  pname = "terragrunt-atlantis-config";
  version = "1.21.1";

  src = fetchFromGitHub {
    owner = "transcend-io";
    repo = "terragrunt-atlantis-config";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lh5c5+Lj2jb9BrM3piG9ERUjluiN0f/sPYp4OyKzYBw=";
  };

  vendorHash = "sha256-brTFOsO2tgWlli1z0W0DGh7114iSlTMHlSZWoFmGdAs=";

  env.CGO_ENABLED = 0;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  doCheck = false; # requires network access

  ldflags = [
    "-X main.VERSION=${finalAttrs.version}"
  ];

  meta = {
    homepage = "https://github.com/transcend-io/terragrunt-atlantis-config";
    changelog = "https://github.com/transcend-io/terragrunt-atlantis-config/releases/tag/v${finalAttrs.version}";
    description = "Generate Atlantis Config for Terragrunt projects";
    mainProgram = "terragrunt-atlantis-config";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      yethal
    ];
  };
})
