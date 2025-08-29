{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  cairo,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tdf";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "itsjunetime";
    repo = "tdf";
    fetchSubmodules = true;
    tag = "v${finalAttrs.version}";
    hash = "sha256-le2xlSVnYbWMDV9+SbrTFHSFZn/H6N7CEaKr5Zzo/c4=";
  };

  cargoHash = "sha256-UB7G5tl90CNq/aYUaUOpgGJcEL9ND3pJ29/lpIkh2iU=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    rustPlatform.bindgenHook
    cairo
  ];

  # Tests depend on cpuprofiler, which is not packaged in nixpkgs
  doCheck = false;

  # requires nightly features (feature(portable_simd))
  RUSTC_BOOTSTRAP = true;

  meta = {
    description = "Tui-based PDF viewer";
    homepage = "https://github.com/itsjunetime/tdf";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      luftmensch-luftmensch
      DieracDelta
    ];
    mainProgram = "tdf";
    platforms = lib.platforms.unix;
  };
})
