{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  wizer,
}:

rustPlatform.buildRustPackage rec {
  pname = "wizer";
  version = "11.0.3";

  # the crate does not contain files which are necessary for the tests
  # see https://github.com/bytecodealliance/wizer/commit/3a95e27ce42f1fdaef07b52988e4699eaa221e04
  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wizer";
    tag = "v${version}";
    hash = "sha256-gGO09/aHkSN8Q7EcKc7FO761YOkliHt9t7iXP4EB1Fc=";
  };

  cargoHash = "sha256-4pH8bCTYaydgVRw6+hRN3326VGlRRMH9/5GhdPsr5Ok=";

  cargoBuildFlags = [
    "--bin"
    pname
  ];

  buildFeatures = [
    "cli"
  ];

  # Setting $HOME to a temporary directory is necessary to prevent checks from failing, as
  # the test suite creates a cache directory at $HOME/Library/Caches/BytecodeAlliance.wasmtime.
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  passthru.tests = {
    version = testers.testVersion { package = wizer; };
  };

  meta = {
    description = "WebAssembly pre-initializer";
    mainProgram = "wizer";
    homepage = "https://github.com/bytecodealliance/wizer";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      lucperkins
    ];
  };
}
