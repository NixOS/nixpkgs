{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  weaver,
}:

rustPlatform.buildRustPackage rec {
  pname = "weaver";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "weaver";
    rev = "v${version}";
    hash = "sha256-FBf+X0Xs3Yr9Sk5v86f2N9WOyv/rW/RSGlAYJ6UCBGY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-rxBij00NQySBVK3lJSm5rWo4YUZZvxk6tnNUzCj75FQ=";

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
}
