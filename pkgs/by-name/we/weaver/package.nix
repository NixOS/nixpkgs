{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "weaver";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "weaver";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kEGz6alm+P6zKR4vxzsyZ67R99tVBjEIK0OEx6SzdvQ=";
  };

  cargoHash = "sha256-//nPXBUi7swKPusaamSJdsUTObnyh+wNc7i8CoyGWrU=";

  checkFlags = [
    # Skip tests requiring network
    "--skip=test_cli_interface"
  ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "OpenTelemetry tool for dealing with semantic conventions and application telemetry schemas";
    homepage = "https://github.com/open-telemetry/weaver";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "weaver";
  };
})
