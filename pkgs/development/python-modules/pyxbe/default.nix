{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyxbe";
  version = "1.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "XboxDev";
    repo = "pyxbe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MtkY4vwPvlYoS4ws8MzIFR8D6ORVqFXA0JvOEspzmtQ=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "xbe" ];

  meta = {
    description = "Library to work with XBE files";
    homepage = "https://github.com/XboxDev/pyxbe";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
