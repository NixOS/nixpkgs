{ lib
, fetchFromGitHub
, rustPlatform
, gmp
, libmpc
, mpfr
, openssl
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "scryer-prolog";
  version = "0.8.127";

  src = fetchFromGitHub {
    owner = "mthom";
    repo = "scryer-prolog";
    rev = "v${version}";
    sha256 = "0307yclslkdx6f0h0101a3da47rhz6qizf4i8q8rjh4id8wpdsn8";
  };

  # Use system openssl, gmp, mpc and mpfr.
  cargoPatches = [ ./cargo.patch ];

  cargoSha256 = "1vf7pfhvpk7ikzibdccw7xgbywv5n4vvshjwsdsf94bhl2knrlg3";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl gmp libmpc mpfr ];

  meta = with lib; {
    description = "A modern Prolog implementation written mostly in Rust.";
    homepage = "https://github.com/mthom/scryer-prolog";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ malbarbo ];
  };
}
