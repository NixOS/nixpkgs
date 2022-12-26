{ lib
, buildPythonPackage
, fetchPypi
, python-dateutil
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "python-crontab";
  version = "2.7.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-shr0ZHx7u4SP7y8CBhbGsCidy5+UtPmRpVMQ/5vsV0k=";
  };

  propagatedBuildInputs = [
    python-dateutil
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    "test_07_non_posix_shell"
    # doctest that assumes /tmp is writeable, awkward to patch
    "test_03_usage"
  ];

  pythonImportsCheck = [
    "crontab"
  ];

  meta = with lib; {
    description = "Python API for crontab";
    longDescription = ''
      Crontab module for reading and writing crontab files
      and accessing the system cron automatically and simply using a direct API.
    '';
    homepage = "https://gitlab.com/doctormo/python-crontab/";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ kfollesdal ];
  };
}
