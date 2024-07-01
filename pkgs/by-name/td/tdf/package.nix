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
  version = "0-unstable-2024-05-29";

  src = fetchFromGitHub {
    owner = "itsjunetime";
    repo = "tdf";
    fetchSubmodules = true;
    rev = "017596a8b0745a6da7c3c75a5f55073b82202a5c";
    hash = "sha256-H0xdDvWDSkvIy4vFWKiVFP03CogswIZMQ393BeEy2BQ=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ratatui-0.26.3" = "sha256-lRQQJqt9UKZ2OzvrNzq/FqDvU6CgPPDAB2QDB7TR1V4=";
      "ratatui-image-1.0.0" = "sha256-0lrFmXPljKKNIbLNhQsuCv7HhJOJ234HSfUPj4XSeXY=";
      "vb64-0.1.2" = "sha256-VvObgaJhHNah3exVQInFa5mhHjzEg0MaFqQdnCE5Pp8=";
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
