{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  writableTmpDirAsHomeHook,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "vulncheck";
  version = "1.3.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "vulncheck-oss";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Pi0NyfCK+v3XeiouV52ykylcEITAbO/eucsU5U46i0E=";
  };

  subPackages = [ "cmd/vulncheck/" ];

  vendorHash = "sha256-UkjaVXGa5BL2QJfBGcQOFLV3LgrmtfqtGw4yQkqvr4c=";

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-X=github.com/vulncheck-oss/cli/internal/build.Version=${finalAttrs.version}"
    "-X=github.com/vulncheck-oss/cli/internal/build.Date=1970-01-01T00:00:00Z"
  ];

  doInstallCheck = true;

  versionCheckProgramArg = [ "version" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command line tool for VulnCheck";
    homepage = "https://github.com/vulncheck-oss/cli";
    changelog = "https://github.com/vulncheck-oss/cli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "vulncheck";
  };
})
