{
  lib,
  buildPythonPackage,
  fetchPypi,
  fastprogress,
  fastcore,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "fastdownload";
  version = "0.0.7";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IFB+246JQGofvXd15uKj2BpN1jPdUGsOnPDhYT6DHWo=";
  };

  propagatedBuildInputs = [
    fastprogress
    fastcore
  ];

  # no real tests
  doCheck = false;
  pythonImportsCheck = [ "fastdownload" ];

  meta = with lib; {
    homepage = "https://github.com/fastai/fastdownload";
    description = "Easily download, verify, and extract archives";
    license = licenses.asl20;
    maintainers = with maintainers; [ rxiao ];
  };
}
