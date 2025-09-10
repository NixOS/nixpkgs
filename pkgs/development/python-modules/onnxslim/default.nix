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
  version = "0.1.62";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-f9SYFsqIM1h+W62ut3gezrNvv02mMVM/Q9UONJsE2Wg=";
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
    description = "Toolkit to Help Optimize Onnx Model";
    homepage = "https://pypi.org/project/onnxslim/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ferrine ];
  };
}
