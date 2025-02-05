{
  lib,
  buildPythonPackage,
  fetchurl,
  fetchPypi,
  setuptools,
  pybind11,
  requests,
  rich,
  pillow,
}:

let
  test-image = fetchurl {
    name = "test-image.jpg";
    url = "https://unsplash.com/photos/u9tAl8WR3DI/download";
    hash = "sha256-shGNdgOOydgGBtl/JCbTJ0AYgl+2xWvCgHBL+bEoTaE=";
  };
in
buildPythonPackage rec {
  pname = "materialyoucolor";
  version = "2.0.10";
  pyproject = true;

  # PyPI sources contain additional vendored sources
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MbTUB7mk/UtUswVZsNAxP21tofnRm3VUbtZdpSZx6nY=";
  };

  build-system = [
    setuptools
    pybind11
  ];

  nativeCheckInputs = [
    requests
    rich
    pillow
  ];

  checkPhase = ''
    runHook preCheck
    python tests/test_all.py ${test-image} 1
    runHook postCheck
  '';

  pythonImportsCheck = [
    "materialyoucolor"
    "materialyoucolor.quantize" # ext
  ];

  meta = {
    description = "Material You color generation algorithms in python";
    homepage = "https://github.com/T-Dynamos/materialyoucolor-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
