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
  version = "2.8.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lgUBxf8vef9HnAWh2eNxtFRMeHxDjucJrZEcONq9DK8=";
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
