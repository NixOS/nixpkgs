{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "versitygw";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "versity";
    repo = "versitygw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-O3rXqg0wSAb4YXxgXqf42oo9sJinZhZ1U6e5WCnvo9I=";
  };

  vendorHash = "sha256-8WrGFLIoXmHQmyFGhOjBAFkaYZ1xhx0aldpyZULfAL4=";

  excludedPackages = [
    "plugins/noop"
    "tests/checker"
    "tests/rest_scripts"
  ];

  # Needed for "versitygw --version" to not show placeholders
  ldflags = [
    "-X main.Build=v${finalAttrs.version}"
    "-X main.BuildTime=1980-01-01T00:00:02Z"
    "-X main.Version=v${finalAttrs.version}"
  ];

  # requires real s3
  checkFlags = [ "-skip=^TestIntegration$" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Versity S3 gateway, a high-performance S3 translation service";
    homepage = "https://github.com/versity/versitygw";
    changelog = "https://github.com/versity/versitygw/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      adamcstephens
      genga898
    ];
    mainProgram = "versitygw";
  };
})
