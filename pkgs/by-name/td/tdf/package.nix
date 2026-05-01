{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  cairo,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tdf";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "itsjunetime";
    repo = "tdf";
    fetchSubmodules = true;
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZC7yQt2ssbRWP7EP7QBrLe8mN9Z9Va4eLivEP/78YpM=";
  };

  cargoHash = "sha256-8JGiKlVr41YbG+mI/S0xPByKa4pwAH4cDVlznRcfCxE=";

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

  # Only used for development
  postInstall = ''
    rm "$out/bin/for_profiling"
  '';
})
