{ lib
, rustPlatform
, fetchFromGitHub
, rustfmt
, perl
}:

rustPlatform.buildRustPackage rec {
  pname = "cairo";
  version = "2.8.2";

  src = fetchFromGitHub {
    owner = "starkware-libs";
    repo = "cairo";
    rev = "v${version}";
    hash = "sha256-vBdIGkdQa/csqsu4DbgIYitVbDLDUAFmIUytZ7IcxNk=";
  };

  cargoHash = "sha256-w3kzEM34HYQ6KgILaDpmZbCgAh8Ql24DRe12woUAhVI=";

  # openssl crate requires perl during build process
  nativeBuildInputs = [
    perl
  ];

  nativeCheckInputs = [
    rustfmt
  ];

  checkFlags = [
    # Requires a mythical rustfmt 2.0 or a nightly compiler
    "--skip=golden_test::sourcegen_ast"

    # Test broken
    "--skip=test_lowering_consistency"
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
