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
  version = "0.1.57";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VI1OaNMHuL2AhYxZ/n5zrwlqnfcCbjY39QXHX8gcdw8=";
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
