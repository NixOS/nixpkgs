{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  colorama,
  onnx,
  packaging,
  sympy,
}:

buildPythonPackage (finalAttrs: {
  pname = "onnxslim";
  version = "0.1.94";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "inisis";
    repo = "OnnxSlim";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AJYNoHw2tq4R3bFFqLx+AAEEKOs8IQj2qayZWvmb+Xk=";
  };

  build-system = [
    hatchling
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
})
