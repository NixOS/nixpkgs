{
  lib,
  buildPythonPackage,
  cloudpickle,
  fastcore,
  fastdownload,
  fastprogress,
  fasttransform,
  fetchPypi,
  matplotlib,
  pandas,
  pillow,
  plum-dispatch,
  requests,
  scikit-learn,
  scipy,
  setuptools,
  spacy,
  torchvision,
}:

buildPythonPackage (finalAttrs: {
  pname = "fastai";
  version = "2.8.6";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-eZW96Upogr6qws6lD8eX2kywuBmTXsbG7vaQKLwx9y8=";
  };

  build-system = [ setuptools ];

  pythonRemoveDeps = [ "pip" ];

  dependencies = [
    cloudpickle
    fastprogress
    fastcore
    fastdownload
    fasttransform
    torchvision
    matplotlib
    pillow
    scikit-learn
    scipy
    spacy
    pandas
    plum-dispatch
    requests
  ];

  doCheck = false;
  pythonImportsCheck = [ "fastai" ];

  meta = {
    homepage = "https://github.com/fastai/fastai";
    description = "Fastai deep learning library";
    mainProgram = "configure_accelerate";
    changelog = "https://github.com/fastai/fastai/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rxiao ];
  };
})
