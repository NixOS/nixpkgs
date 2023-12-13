{ lib
, rustPlatform
, fetchFromGitHub
, fetchpatch
, pkg-config
, openssl
, gmp
, libmpc
, mpfr
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "scryer-prolog";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "mthom";
    repo = "scryer-prolog";
    rev = "v${version}";
    hash = "sha256-0J69Zl+ONvR6T+xf2YeShwn3/JWOHyFHLpNFwmEaIOI=";
  };

  patches = [
    (fetchpatch {
      name = "cargo-lock-version-bump.patch";
      url = "https://github.com/mthom/scryer-prolog/commit/d6fe5b5aaddb9886a8a34841a65cb28c317c2913.patch";
      hash = "sha256-xkGsjVV/FcyZXGkI84FlqcRIuDM7isCCWZ1sbKql7es=";
    })
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "modular-bitfield-0.11.2" = "sha256-vcx+xt5owZVWOlKwudAr0EB1zlLLL5pVfWokw034BQI=";
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
    maintainers = with maintainers; [ malbarbo wkral ];
  };
}
