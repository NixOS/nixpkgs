{ lib
, rustPlatform
, fetchFromGitHub
, rustfmt
}:

rustPlatform.buildRustPackage rec {
  pname = "cairo";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "starkware-libs";
    repo = "cairo";
    rev = "v${version}";
    hash = "sha256-8dzDe4Kw9OASD0i3bMooqEclStxS/Ta/tOVCcFhvwSI=";
  };

  cargoHash = "sha256-IY3RE+EeNRhUSZX+bqojhPl6y8qm+i9C0zQmNApmat8=";

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
