{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  cairo,
  glib,
  poppler,
}:

rustPlatform.buildRustPackage {
  pname = "tdf";
  version = "0-unstable-2024-10-09";

  src = fetchFromGitHub {
    owner = "itsjunetime";
    repo = "tdf";
    fetchSubmodules = true;
    rev = "f6d339923bc71d3f637f24bf0c6eef6dacb61bf9";
    hash = "sha256-C1S5u1EsOYvUE1CqreeBg7Z5Oj+mzCf0zPdZBz0LNLw=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ratatui-0.28.1" = "sha256-riVdXpHW5J1f4YY2A32YLpwydxn/kJ1cHRdm7CCdoN8=";
      "ratatui-image-2.0.1" = "sha256-ZFd7ABeyuO270vWEZEE685Bil6sq3RndqoD7TSU8qmU=";
      "vb64-0.1.2" = "sha256-Ypb59Rtn0ZkP6fwqIqOEeiNLcmzB368CkViIVCxpCI8=";
    };
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    cairo
    glib
    poppler
  ];

  strictDeps = true;

  # No tests are currently present
  doCheck = false;

  # requires nightly features (feature(portable_simd))
  RUSTC_BOOTSTRAP = true;

  meta = {
    description = "Tui-based PDF viewer";
    homepage = "https://github.com/itsjunetime/tdf";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "tdf";
    platforms = lib.platforms.linux;
  };
}
