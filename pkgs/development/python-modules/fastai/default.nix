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
}:

buildPythonPackage rec {
  pname = "fastai";
  version = "2.8.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kq7ndxj8h5nBJTZ8wVenqSquZ6CoqTyde4lQO9rFybY=";
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

  meta = {
    homepage = "https://github.com/fastai/fastai";
    description = "Fastai deep learning library";
    mainProgram = "configure_accelerate";
    changelog = "https://github.com/fastai/fastai/blob/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rxiao ];
  };
}
