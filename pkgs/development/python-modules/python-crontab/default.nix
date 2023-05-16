{ lib
, buildPythonPackage
, fetchPypi
, python-dateutil
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "python-crontab";
<<<<<<< HEAD
  version = "3.0.0";
=======
  version = "2.7.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-eft0ZQOd39T7k9By1u4NRcGsi/FZfwaG6hT9Q2Hbo3k=";
=======
    hash = "sha256-shr0ZHx7u4SP7y8CBhbGsCidy5+UtPmRpVMQ/5vsV0k=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    python-dateutil
  ];

  nativeCheckInputs = [
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
