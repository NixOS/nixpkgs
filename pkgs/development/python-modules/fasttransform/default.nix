{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  fastcore,
  numpy,
  plum-dispatch,
}:

buildPythonPackage (finalAttrs: {
  pname = "fasttransform";
  version = "0.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AnswerDotAI";
    repo = "fasttransform";
    tag = finalAttrs.version;
    hash = "sha256-hGIbUzKW1HevBPUeh536nRoO2d48yPweurj4ozYxLr4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    fastcore
    numpy
    plum-dispatch
  ];

  pythonImportsCheck = [ "fasttransform" ];

  # No tests
  doCheck = false;

  meta = {
    description = "Main building block of data pipelines in fastai";
    homepage = "https://github.com/AnswerDotAI/fasttransform";
    changelog = "https://github.com/AnswerDotAI/fasttransform/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
