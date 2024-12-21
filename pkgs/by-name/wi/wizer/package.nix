{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  wizer,
}:

rustPlatform.buildRustPackage rec {
  pname = "wizer";
  version = "7.0.5";

  # the crate does not contain files which are necessary for the tests
  # see https://github.com/bytecodealliance/wizer/commit/3a95e27ce42f1fdaef07b52988e4699eaa221e04
  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wizer";
    rev = "refs/tags/v${version}";
    hash = "sha256-bx8V/jaKDpJdWRwYm6GrjsdXQpDyTulRMKVnQZlqLNE=";
  };

  cargoHash = "sha256-8iQ6ULdle8tJDPgIoPT9R3jfS32tBBfs4vZNQcV8vfs=";

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
