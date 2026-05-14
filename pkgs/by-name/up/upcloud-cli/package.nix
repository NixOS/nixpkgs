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
  version = "3.33.0";

  src = fetchFromGitHub {
    owner = "UpCloudLtd";
    repo = "upcloud-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vI7GqVP0v0HkZE9gaj8a1N2TRZVDqb5OOA0ozMSLYpM=";
  };

  vendorHash = "sha256-iVg3nFC5YLeoVR5dlkzsAZkLHi6bDMr18GD6r7fOMis=";

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
