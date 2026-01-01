{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  cairo,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tdf";
<<<<<<< HEAD
  version = "0.5.0";
=======
  version = "0.4.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "itsjunetime";
    repo = "tdf";
    fetchSubmodules = true;
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-YjIMuwQkPtwlGiQ2zs3lEZi28lfn9Z5b5zOYIDFf5qw=";
  };

  cargoHash = "sha256-lGbsb3hlFen0tXBVLbm8+CE5dddv6Ner4YSAvAd3/ug=";

  nativeBuildInputs = [ pkg-config ];

  buildFeatures = [
    "epub"
    "cbz"
  ];

=======
    hash = "sha256-ZC7yQt2ssbRWP7EP7QBrLe8mN9Z9Va4eLivEP/78YpM=";
  };

  cargoHash = "sha256-8JGiKlVr41YbG+mI/S0xPByKa4pwAH4cDVlznRcfCxE=";

  nativeBuildInputs = [ pkg-config ];

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  buildInputs = [
    rustPlatform.bindgenHook
    cairo
  ];

  # Tests depend on cpuprofiler, which is not packaged in nixpkgs
  doCheck = false;

<<<<<<< HEAD
=======
  # requires nightly features (feature(portable_simd))
  RUSTC_BOOTSTRAP = true;

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
