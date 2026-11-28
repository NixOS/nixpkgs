{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  lxml,
  pillow,
  typing-extensions,
  uv-build,
}:
buildPythonPackage (finalAttrs: {
  pname = "odfdo";
  version = "3.27.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jdum";
    repo = "odfdo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-U5qO8JN6W4TCvSUI7Z5Mv+RxPRvTUphTCPgS3obg7bA=";
  };

  build-system = [ uv-build ];

  dependencies = [
    lxml
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pillow
  ];

  meta = {
    changelog = "https://github.com/jdum/odfdo/blob/${finalAttrs.src.tag}/CHANGES.md";
    description = "OpenDocument Format (ODF, ISO/IEC 26300) library for Python";
    homepage = "https://github.com/jdum/odfdo";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ungeskriptet ];
  };
})
