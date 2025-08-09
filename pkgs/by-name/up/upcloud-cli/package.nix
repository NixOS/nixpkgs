{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  dbus,
}:

buildGoModule (finalAttrs: {
  pname = "upcloud-cli";
  version = "3.21.0";

  src = fetchFromGitHub {
    owner = "UpCloudLtd";
    repo = "upcloud-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GN/GIqppSXDexe2KRH1RoVpm8HUkvsnul3H+q4OcjOA=";
  };

  vendorHash = "sha256-Z2Eumhsn/YmHopgpKBFGs4HmDdUl/cr+R6bRaeCFQtE=";

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
