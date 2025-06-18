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
  version = "0.1.56";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/c2id6XH0QQUdiISRlC8YDZNAm7E+8sEdfYfgv8J0Mw=";
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
