{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  lxml,
  pillow,
  uv-build,
}:
buildPythonPackage (finalAttrs: {
  pname = "odfdo";
  version = "3.22.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jdum";
    repo = "odfdo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1cOi7aAJ8jWjLuQbhd7aK5s2rJ5IvkTLIl9atKmXKMU=";
  };

  build-system = [ uv-build ];

  dependencies = [ lxml ];

  nativeCheckInputs = [
    pytestCheckHook
    pillow
  ];

  meta = {
    description = "OpenDocument Format (ODF, ISO/IEC 26300) library for Python";
    homepage = "https://github.com/jdum/odfdo";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ungeskriptet ];
  };
})
