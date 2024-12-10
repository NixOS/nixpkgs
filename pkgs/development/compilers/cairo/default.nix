{
  lib,
  rustPlatform,
  fetchFromGitHub,
  rustfmt,
}:

rustPlatform.buildRustPackage rec {
  pname = "cairo";
  version = "2.5.4";

  src = fetchFromGitHub {
    owner = "starkware-libs";
    repo = "cairo";
    rev = "v${version}";
    hash = "sha256-ctb5VingMczzHLyyEjKgFKNAZI3/fqzjFW/RQGDSsyQ=";
  };

  cargoHash = "sha256-T21GuGQaX/VD907MEGp68bQPXrRK0it4o1nLEdHwTsE=";

  nativeCheckInputs = [
    rustfmt
  ];

  checkFlags = [
    # Requires a mythical rustfmt 2.0 or a nightly compiler
    "--skip=golden_test::sourcegen_ast"
  ];

  postInstall = ''
    # The core library is needed for compilation.
    cp -r corelib $out/
  '';

  meta = with lib; {
    description = "Turing-complete language for creating provable programs for general computation";
    homepage = "https://github.com/starkware-libs/cairo";
    license = licenses.asl20;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
