{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  cloudpickle,
  fastcore,
  fastdownload,
  fastprogress,
  fasttransform,
  matplotlib,
  packaging,
  pandas,
  pillow,
  plum-dispatch,
  pyyaml,
  requests,
  scikit-learn,
  scipy,
  spacy,
  torch,
  torchvision,
}:

buildPythonPackage (finalAttrs: {
  pname = "fastai";
  version = "2.8.7";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fastai";
    repo = "fastai";
    tag = finalAttrs.version;
    hash = "sha256-qjBVqSVQV+v1Uc95Tz8NyLkKwCLdG+R7MkH+CugzY1Q=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    cloudpickle
    fastcore
    fastdownload
    fastprogress
    fasttransform
    matplotlib
    packaging
    pandas
    pillow
    plum-dispatch
    pyyaml
    requests
    scikit-learn
    scipy
    spacy
    torch
    torchvision
  ];

  pythonImportsCheck = [ "fastai" ];

  # Tests fail at collection with:
  #   fixture 'f' not found
  doCheck = false;

  meta = {
    description = "Fastai deep learning library";
    homepage = "https://github.com/fastai/fastai";
    mainProgram = "configure_accelerate";
    changelog = "https://github.com/fastai/fastai/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rxiao ];
  };
})
