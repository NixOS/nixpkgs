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
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "itsjunetime";
    repo = "tdf";
    fetchSubmodules = true;
    rev = "e16163efb87e63e692cd2929180ea29def09ba89";
    hash = "sha256-FezpqyoAtfWoX78APTSWjG9vMJr8FMqy402HuIas3/0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-NynxXp6+SM9R9xfbFeLyCvLxiQyRW6LDvlo6QWPBXvs=";

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
    maintainers = with lib.maintainers; [
      luftmensch-luftmensch
      DieracDelta
    ];
    mainProgram = "tdf";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
