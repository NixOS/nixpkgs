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
  version = "3.25.0";

  src = fetchFromGitHub {
    owner = "UpCloudLtd";
    repo = "upcloud-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uxlFqXLjZ62CYpR/NRj2MG0MlSwa58P3MfG49/zQ1TI=";
  };

  vendorHash = "sha256-WQf+ZZH+pKK3zeDRlKyriLIcHKZXdFdCU/K9LvFgT3k=";

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
