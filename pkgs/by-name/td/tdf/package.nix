{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  versionCheckHook,
  cairo,
  brotli,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tdf";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "itsjunetime";
    repo = "tdf";
    fetchSubmodules = true;
    tag = "v${finalAttrs.version}";
    hash = "sha256-YjIMuwQkPtwlGiQ2zs3lEZi28lfn9Z5b5zOYIDFf5qw=";
  };

  cargoHash = "sha256-lGbsb3hlFen0tXBVLbm8+CE5dddv6Ner4YSAvAd3/ug=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    pkg-config
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  buildFeatures = [
    "epub"
    "cbz"
  ];

  buildInputs = [
    cairo
    brotli
  ];

  env.CARGO_FEATURE_SYS_LIB_BROTLI = "1";

  doCheck = true;

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
