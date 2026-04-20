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
  version = "3.22.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jdum";
    repo = "odfdo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Jf0bYxPs9IliPAUI7onYZWosWcr/5QnjS0QRF12LFkQ=";
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
