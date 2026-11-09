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
  version = "2.8.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fastai";
    repo = "fastai";
    tag = finalAttrs.version;
    hash = "sha256-VTyBBU3yCW08VxJbKASo0vwTudj/g81FwiOVqplaqqw=";
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
