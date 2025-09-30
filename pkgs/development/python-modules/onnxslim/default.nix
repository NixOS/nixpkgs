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
  version = "0.1.69";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "inisis";
    repo = "OnnxSlim";
    tag = "v${version}";
    hash = "sha256-UwuZDAPTwIVJTseu8iIO2Q8OOaFcwiwLS/auWOpIpnQ=";
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
    maintainers = with lib.maintainers; [ ferrine ];
  };
}
