{ lib
, buildPythonPackage
, fetchPypi
, psutil
}:

buildPythonPackage rec {
  pname = "python-pidfile";
  version = "3.1.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pgQBL2iagsHMRFEKI85ZwyaIL7kcIftAy6s+lX958M0=";
  };

  propagatedBuildInputs = [
    psutil
  ];

  pythonImportsCheck = [ "pidfile" ];

  # no tests on the github mirror of the source code
  # see this: https://github.com/mosquito/python-pidfile/issues/7
  doCheck = false;

  meta = with lib; {
    description = "Python context manager for managing pid files";
    homepage = "https://github.com/mosquito/python-pidfile";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ lom ];
  };
}
