{
  lib,
  buildGo125Module,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  dbus,
}:

buildGo125Module (finalAttrs: {
  pname = "upcloud-cli";
  version = "3.22.0";

  src = fetchFromGitHub {
    owner = "UpCloudLtd";
    repo = "upcloud-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-37e5eJdKqUMlipcViFC4bTtZSlL3PgjjPiTO3PJWpTw=";
  };

  vendorHash = "sha256-F1QUH0+FMmpt05G50PfDryfzbBHvDLCMQMb8qAo6BR4=";

  ldflags = [
    "-s -w -X github.com/UpCloudLtd/upcloud-cli/v3/internal/config.Version=${finalAttrs.version}"
  ];

  subPackages = [
    "cmd/upctl"
    "internal/*"
  ];

  nativeCheckInputs = [ dbus ];

  checkFlags =
    let
      skippedTests = [
        "TestConfig_LoadKeyring" # Not equal: expected: "unittest_password" actual  : ""
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/upctl";
  versionCheckProgramArg = "version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/UpCloudLtd/upcloud-cli/blob/refs/tags/v${finalAttrs.version}/CHANGELOG.md";
    description = "Command-line tool for managing UpCloud services";
    homepage = "https://github.com/UpCloudLtd/upcloud-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lu1a ];
    mainProgram = "upctl";
  };
})
