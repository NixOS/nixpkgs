{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  onnx,
  packaging,
  sympy,
}:

buildPythonPackage rec {
  pname = "onnxslim";
  version = "0.1.61";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3u0MBbO3FOK2yllfGYzG9UBxd9je1p40rp12j226F2g=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    onnx
    packaging
    sympy
  ];

  pythonImportsCheck = [
    "onnxslim"
  ];

  meta = {
    description = "A Toolkit to Help Optimize Onnx Model";
    homepage = "https://pypi.org/project/onnxslim/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ferrine ];
  };
}
