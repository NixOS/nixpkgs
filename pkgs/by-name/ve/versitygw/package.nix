{
  lib,
  fetchFromGitHub,
  buildGoModule,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "versitygw";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "versity";
    repo = "versitygw";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ike6iFIRAb8ENjNp+jl8joP0bnei7AEaNvZFlosB3n0=";
  };

  vendorHash = "sha256-/dGRcQr/XgZV2h8Eju2/Reo3W6cBuYS2gDv/FddQ8ow=";

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
        "^TestFsyncPutObject"
        "^TestFsyncFailureFailsThePut$"
        "^TestListObjectsV2ContinuationTokenEcho$"
        "^TestObjectLockModeNoneRejectsConditionalWrites$"
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
