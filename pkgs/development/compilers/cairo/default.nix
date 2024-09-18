{ lib
, rustPlatform
, fetchFromGitHub
, rustfmt
, perl
}:

rustPlatform.buildRustPackage rec {
  pname = "cairo";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "starkware-libs";
    repo = "cairo";
    rev = "v${version}";
    hash = "sha256-zQ+kc4c8YI9vURUEQNqX55mTJBcc2NLp4K8kab3ZjEs=";
  };

  cargoHash = "sha256-3ah6cHyCppkLJ2e73aGhVemyMRBl9R5a6ufWHmrJHSk=";

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
