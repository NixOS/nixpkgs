{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  meson,
  meson-python,
  numpy,
  setuptools,
}:

buildPythonPackage rec {
  pname = "numpy-financial";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "numpy";
    repo = "numpy-financial";
    tag = "v${version}";
    hash = "sha256-6hSi5Y292Ikfb2m2SLvIHJS0nZcGKgGzvybgmpxReWI=";
  };

  build-system = [
    meson
    meson-python
    setuptools
  ];

  dependencies = [ numpy ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "numpy_financial" ];

  meta = {
    homepage = "https://numpy.org/numpy-financial/";
    changelog = "https://github.com/numpy/numpy-financial/releases/tag/v${version}";
    description = "Collection of elementary financial functions";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ flokli ];
  };
}
