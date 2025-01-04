{
  lib,
  buildPythonPackage,
  fetchPypi,
  fastprogress,
  fastcore,
  fastdownload,
  torchvision,
  matplotlib,
  pillow,
  scikit-learn,
  scipy,
  spacy,
  pandas,
  requests,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "fastai";
  version = "2.7.18";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sgWT28rnUi8dd6j1Fj0f1gMU8pJkBJaATcNW5ByzZFQ=";
  };

  propagatedBuildInputs = [
    fastprogress
    fastcore
    fastdownload
    torchvision
    matplotlib
    pillow
    scikit-learn
    scipy
    spacy
    pandas
    requests
  ];

  doCheck = false;
  pythonImportsCheck = [ "fastai" ];

  meta = with lib; {
    homepage = "https://github.com/fastai/fastai";
    description = "Fastai deep learning library";
    mainProgram = "configure_accelerate";
    changelog = "https://github.com/fastai/fastai/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ rxiao ];
  };
}
