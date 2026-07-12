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
  version = "0.1.93";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "inisis";
    repo = "OnnxSlim";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RnUBOTRlxtyy2QaAFaAHA664CzLNoBUwfYkhPysYOJo=";
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
