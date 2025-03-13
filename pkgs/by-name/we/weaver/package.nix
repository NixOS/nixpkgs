{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  weaver,
}:

rustPlatform.buildRustPackage rec {
  pname = "weaver";
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "open-telemetry";
    repo = "weaver";
    rev = "v${version}";
    hash = "sha256-kfBWI+1f39oSSKYflXfXnBTc96OZch7o5HWfOgOfuxs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-KK6Cp6viQPp9cSxs1dP1tf/bIMgkKiaKPE6VytyHyZA=";

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
