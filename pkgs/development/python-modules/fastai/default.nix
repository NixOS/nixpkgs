{ lib
, buildPythonPackage
, fetchPypi
, fastprogress
, fastcore
, fastdownload
, torch
, torchvision
, matplotlib
, pillow
, scikit-learn
, scipy
, spacy
, pandas
, requests
, pythonOlder
}:

buildPythonPackage rec {
  pname = "fastai";
  version = "2.7.13";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-q1KBBAAKrTzq6USRwBjvT23mXpjQT2gjBsxuZ4w54rY=";
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
    description = "The fastai deep learning library";
    changelog = "https://github.com/fastai/fastai/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ rxiao ];
  };
}
