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
<<<<<<< HEAD
  version = "0.1.78";
=======
  version = "0.1.70";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "inisis";
    repo = "OnnxSlim";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-xLT00z9zeO4o5JN9W+5AfpANjc2+qAtFNnncLJptCoA=";
=======
    hash = "sha256-xShmJR0GWuGmuM0LZ0nBLDoC0m7c0iSWolUGUscVotA=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
=======
    maintainers = with lib.maintainers; [ ferrine ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
