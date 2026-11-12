{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  oniguruma,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tenere";
  version = "0.11.3";
  src = fetchFromGitHub {
    owner = "pythops";
    repo = "tenere";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iuGsDSdlNL3xc9qtMOdte1mzjmWZHieKGLHDi3XLg2g=";
  };

  cargoHash = "sha256-okIn32IA6ZizfS2XjHxq8cPRIZzvZ4kIz1NI0X72Tfs=";

  requiredSystemFeatures = [ "big-parallel" ]; # for fat LTO from upstream

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    oniguruma
  ];

  # Let libgit2-sys use its bundled libgit2 because nixpkgs' libgit2 is newer
  # than the version this package supports. Revisit after updating the package.
  preBuild = ''
    unset LIBGIT2_NO_VENDOR
  '';

  meta = {
    description = "Terminal interface for large language models (LLMs)";
    homepage = "https://github.com/pythops/tenere";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ob7 ];
    mainProgram = "tenere";
  };
})
