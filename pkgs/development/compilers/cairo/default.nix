{ lib
, rustPlatform
, fetchFromGitHub
, rustfmt
, stdenv
, pkg-config
, openssl
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "cairo";
  version = "2.8.4";

  src = fetchFromGitHub {
    owner = "starkware-libs";
    repo = "cairo";
    rev = "v${version}";
    hash = "sha256-xHvBbm1ewNu96TyK//l2emiq+jaPhSWvvbVK9Q/O5lo=";
  };

  cargoHash = "sha256-E6nnT+I5ur4PPvLjwfebR1Tdm206hI05HCVc3IWDqFY=";

  env.OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    Security
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
