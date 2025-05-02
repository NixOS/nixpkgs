{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  weaver,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "weaver";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "weaver";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zsDHVa3UqJX0dPg69hQmoTc6d+fx5zHe4+ElFByMb9s=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-30JR9dX+N8KLHeUt8VsGC9LgKUnTtwunWAaXEnzGyWw=";

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
