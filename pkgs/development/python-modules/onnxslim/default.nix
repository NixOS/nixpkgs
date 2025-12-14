{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  colorama,
  onnx,
  packaging,
  sympy,
}:

buildPythonPackage rec {
  pname = "onnxslim";
  version = "0.1.78";
  pyproject = true;

  # moving to pypi due to missing github release
  # move back to github when upgrading
  src = fetchPypi {
    inherit version;
    pname = "onnxslim";
    hash = "sha256-uOGdOyOKbB0/CdEhBjrS4BbtfIUjZkiwHOKAtSV56is=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    colorama
    onnx
    packaging
    sympy
  ];

  pythonImportsCheck = [ "onnxslim" ];

  # __main__.py: error: the following arguments are required: --model-dir
  doCheck = false;

  meta = {
    description = "Toolkit to Help Optimize Onnx Model";
    homepage = "https://pypi.org/project/onnxslim/";
    license = lib.licenses.mit;
  };
}
