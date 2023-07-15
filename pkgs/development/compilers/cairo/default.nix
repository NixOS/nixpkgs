{ lib
, rustPlatform
, fetchFromGitHub
, rustfmt
}:

rustPlatform.buildRustPackage rec {
  pname = "cairo";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "starkware-libs";
    repo = "cairo";
    rev = "v${version}";
    hash = "sha256-tFWY4bqI+YVVu0E9EPl+c0UAsSn/cjgvEOQtyT9tkYg=";
  };

  cargoHash = "sha256-fnkzR07MIwzjvg2ZRhhzYIUhuidEBZt0mGfxwHyhyVE=";

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
