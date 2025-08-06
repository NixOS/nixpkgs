{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  weaver,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "weaver";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "weaver";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fpr6GMUYRkHqy0e9M2qU4qKTiziSmfrHH+EBav7mgeA=";
  };

  cargoHash = "sha256-8+gOEpeM2n3H1nboZgtaMnWXX90eRom1ERnfItPqmFA=";

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
