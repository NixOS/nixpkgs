{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  fastcore,
  numpy,
  plum-dispatch,
}:

buildPythonPackage (finalAttrs: {
  pname = "fasttransform";
  version = "0.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AnswerDotAI";
    repo = "fasttransform";
    tag = finalAttrs.version;
    hash = "sha256-d41645xOXkFv4rjFBfOXepYHGbYiCbHN2O30aePVVxM=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    fastcore
    numpy
    plum-dispatch
  ];

  pythonImportsCheck = [
    "fasttransform"
  ];

  # no tests
  doCheck = false;

  meta = {
    description = "Transform is the main building block of data pipelines in fastai. And elsewhere if you want";
    homepage = "https://github.com/AnswerDotAI/fasttransform";
    changelog = "https://github.com/AnswerDotAI/fasttransform/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
