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
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "weaver";
    rev = "v${version}";
    hash = "sha256-HKVUi/XJsvgj+UnhJRa2PkGlfJHNdz8M/re9vYMu1LM=";
  };

  cargoHash = "sha256-p6NQm4Paq1nDMxmaf3BcZF3V7k6Ifw93BC0InKUjgBk=";

  buildInputs = lib.optionals stdenv.isDarwin (
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
