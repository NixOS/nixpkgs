{
  lib,
  rustPlatform,
  fetchFromGitHub,
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

  meta = {
    description = "Terminal interface for large language models (LLMs)";
    homepage = "https://github.com/pythops/tenere";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ob7 ];
    mainProgram = "tenere";
  };
})
