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

  useFetchCargoVendor = true;
  cargoHash = "sha256-2rR3QY2WH71ghWqUI7kGZS54QwyJ3YSEIMPL09pxLHM=";

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
