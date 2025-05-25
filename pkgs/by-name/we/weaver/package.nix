{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  weaver,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "weaver";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "weaver";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aAxVSk12bPaWbvCWd+ntPeozd/rtQxdu53APWXI6fTg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Sc5tSK/0C8iqwb4yM6Ra2/PcdOdn1UkpUQjgmWmfVBE=";

  checkFlags = [
    # Skip tests requiring network
    "--skip=test_cli_interface"
  ];

  passthru.tests.version = testers.testVersion {
    package = weaver;
  };

  meta = {
    description = "OpenTelemetry tool for dealing with semantic conventions and application telemetry schemas";
    homepage = "https://github.com/open-telemetry/weaver";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "weaver";
  };
})
