{
  lib,
  buildPythonPackage,
  fetchPypi,
  python-dateutil,
  requests,
  six,
  sseclient-py,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "python-nest";
  version = "4.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-01hoZbDssbJ10NA72gOtlzjZMGjsUBUoVDVM35uAOLU=";
  };

  propagatedBuildInputs = [
    python-dateutil
    requests
    six
    sseclient-py
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "nest" ];

<<<<<<< HEAD
  meta = {
    description = "Python API and command line tool for talking to the Nest™ Thermostat";
    homepage = "https://github.com/jkoelker/python-nest";
    license = lib.licenses.cc-by-nc-sa-40;
    maintainers = with lib.maintainers; [ jamiemagee ];
=======
  meta = with lib; {
    description = "Python API and command line tool for talking to the Nest™ Thermostat";
    homepage = "https://github.com/jkoelker/python-nest";
    license = licenses.cc-by-nc-sa-40;
    maintainers = with maintainers; [ jamiemagee ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
