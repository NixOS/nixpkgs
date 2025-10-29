{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "fastprogress";
  version = "1.0.3";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ehfStDiJD4OMBI7vzjLE3tRxl+zI6gQs7MM9PeuAIvU=";
  };

  propagatedBuildInputs = [ numpy ];

  # no real tests
  doCheck = false;
  pythonImportsCheck = [ "fastprogress" ];

  meta = with lib; {
    homepage = "https://github.com/fastai/fastprogress";
    description = "Simple and flexible progress bar for Jupyter Notebook and console";
    license = licenses.asl20;
    maintainers = with maintainers; [ ris ];
  };
}
