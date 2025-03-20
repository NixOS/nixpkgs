{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  wizer,
}:

rustPlatform.buildRustPackage rec {
  pname = "wizer";
  version = "8.0.0";

  # the crate does not contain files which are necessary for the tests
  # see https://github.com/bytecodealliance/wizer/commit/3a95e27ce42f1fdaef07b52988e4699eaa221e04
  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wizer";
    tag = "v${version}";
    hash = "sha256-NaYHrjm5CGPWT5Pa1EdXS9fswj5NDWQye2pBQk+PKuk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-OI7/PLP0Au7FrQ9KUTBTSE9r8kJBA3gbcHe060KALHw=";

  cargoBuildFlags = [
    "--bin"
    pname
  ];

  buildFeatures = [
    "env_logger"
    "structopt"
  ];

  # Setting $HOME to a temporary directory is necessary to prevent checks from failing, as
  # the test suite creates a cache directory at $HOME/Library/Caches/BytecodeAlliance.wasmtime.
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  passthru.tests = {
    version = testers.testVersion { package = wizer; };
  };

  meta = with lib; {
    description = "WebAssembly pre-initializer";
    mainProgram = "wizer";
    homepage = "https://github.com/bytecodealliance/wizer";
    license = licenses.asl20;
    maintainers = with maintainers; [
      lucperkins
      amesgen
    ];
  };
}
