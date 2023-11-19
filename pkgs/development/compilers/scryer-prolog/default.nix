{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, gmp
, libmpc
, mpfr
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "scryer-prolog";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "mthom";
    repo = "scryer-prolog";
    rev = "v${version}";
    hash = "sha256-68wtRFkJh8OIdauSIyJ29en399TLnaRaRxw+5bkykxk=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "dashu-0.3.1" = "sha256-bovPjLs98oj8/e/X/9GIYCzArzGfshjoeHU7IHdnq30=";
      "libffi-3.2.0" = "sha256-GcNcXJCfiJp/7X5FXQJ/St0SmsPlCyeM8/s9FR+VE+M=";
      "modular-bitfield-0.11.2" = "sha256-vcx+xt5owZVWOlKwudAr0EB1zlLLL5pVfWokw034BQI=";
      "num-modular-0.5.2" = "sha256-G4Kr3BMbXprC6tbG3mY/fOi2sQzaepOTeC4vDiOKWUM=";
    };
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl gmp libmpc mpfr ];

  CARGO_FEATURE_USE_SYSTEM_LIBS = true;

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A modern Prolog implementation written mostly in Rust";
    homepage = "https://github.com/mthom/scryer-prolog";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ malbarbo ];
  };
}
