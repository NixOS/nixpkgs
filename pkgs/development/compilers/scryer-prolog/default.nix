{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, rustPlatform
, rustfmt
, gmp
, libmpc
, mpfr
, openssl
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "scryer-prolog";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "mthom";
    repo = "scryer-prolog";
    rev = "v${version}";
    sha256 = "3NHpEg6QaUaqbBCq8uM5hFcqS24q4XrOnKjMmn8Z1Dg=";
  };

  cargoPatches = [
    # Use system openssl, gmp, mpc and mpfr.
    ./cargo.patch

    ./fix-tests.patch

    # Avoid testing failing with "couldn't save history"
    (fetchpatch {
      name = "fix-tests-1";
      url = "https://patch-diff.githubusercontent.com/raw/mthom/scryer-prolog/pull/1342.patch";
      sha256 = "2N0AOkFuf+H/aUn2QTXgmqjmvShTxHxB6kNuNdNoVRI=";
    })
  ];

  cargoSha256 = "nqAHVXAmTW9mdE2L2yhpOTz16JbYgQUmCgiFq9pBzUU=";

  nativeBuildInputs = [ pkg-config rustfmt];
  buildInputs = [ openssl gmp libmpc mpfr ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A modern Prolog implementation written mostly in Rust.";
    homepage = "https://github.com/mthom/scryer-prolog";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ malbarbo ];
  };
}
