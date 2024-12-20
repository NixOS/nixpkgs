{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  darwin,
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

  cargoHash = "sha256-r7l6/xeClphOI9kz/r36P0tTNHmSTKDhRL6KTVZNmvk=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin (
    with darwin.apple_sdk_11_0.frameworks; [ SystemConfiguration ]
  );

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
