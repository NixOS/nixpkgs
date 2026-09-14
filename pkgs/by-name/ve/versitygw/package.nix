{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "versitygw";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "versity";
    repo = "versitygw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fnmhA3Et3rF0GgRdV41rdTrBZCh2b8dvRYTATaqDb18=";
  };

  vendorHash = "sha256-HyDY6tTDvEDQI85Z4SGb11oDPTicnp8TR1sH7n7Bbcg=";

  excludedPackages = [
    # depends on cgo/cuda
    "cmd/cuobjtest"
    "cmd/vgwrdma"
    "rdma"

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

  env.CGO_ENABLED = "0";

  checkFlags =
    let
      skippedTests = [
        # requires real s3
        "^TestIntegration$"

        # requires extended attributes
        "^TestObjectPublishLockHonorsContextWhileWaiting$"
        "/xattr$"
      ];
    in
    [ "-skip=${builtins.concatStringsSep "|" skippedTests}" ];

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
