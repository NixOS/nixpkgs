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
  version = "0.1.53";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lESXknLu/JZ8v92/OGYha/vGdzFMHhT3viaJQFNXj5I=";
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
