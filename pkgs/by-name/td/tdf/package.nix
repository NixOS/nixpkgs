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
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "itsjunetime";
    repo = "tdf";
    fetchSubmodules = true;
    rev = "a2b728fae3c5b0addfa64e8d3e44eac6fd50f1d9";
    hash = "sha256-0as/tKw0nKkZn+5q5PlKwK+LZK0xWXDAdiD3valVjBs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-krIPfi4SM4uCw7NLauudwh1tgAaB8enDWnMC5X16n48=";

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
