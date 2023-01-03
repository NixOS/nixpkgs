{ stdenv
, lib
, fetchFromGitHub
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
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "mthom";
    repo = "scryer-prolog";
    rev = "v${version}";
    sha256 = "bDLVOXX9nv6Guu5czRFkviJf7dBiaqt5O8SLUJlcBZo=";
  };

  cargoPatches = [
    # Use system openssl, gmp, mpc and mpfr.
    ./cargo.patch
  ];

  cargoSha256 = "A6HtvxGTjJliDMUSGkQKB13FRyfBU4EPvrlZ97ic0Ic=";

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
