{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

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
  version = "0.1.80";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "inisis";
    repo = "OnnxSlim";
    tag = "v${version}";
    hash = "sha256-esiNSWvoY4k82ys350hWOrV1SfQzgj6iykt3Ug22YCw=";
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
