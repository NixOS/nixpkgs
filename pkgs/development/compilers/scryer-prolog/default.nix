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
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "mthom";
    repo = "scryer-prolog";
    rev = "v${version}";
    sha256 = "bDLVOXX9nv6Guu5czRFkviJf7dBiaqt5O8SLUJlcBZo=";
  };

  cargoSha256 = "sha256-tv/4GOl93nGLWyoAXY5roxRqS1twskkQTSddltH4n9U=";

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
