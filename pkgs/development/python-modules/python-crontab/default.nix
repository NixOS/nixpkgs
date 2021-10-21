{ lib, buildPythonPackage, fetchPypi, python-dateutil, pytestCheckHook }:

buildPythonPackage rec {
  pname = "python-crontab";
  version = "2.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1e35ed7a3cdc3100545b43e196d34754e6551e7f95e4caebbe0e1c0ca41c2f1b";
  };

  checkInputs = [ pytestCheckHook ];
  disabledTests = [ "test_07_non_posix_shell"];

  propagatedBuildInputs = [ python-dateutil ];

  meta = with lib; {
    description = "Python API for crontab";
    longDescription = ''
      Crontab module for reading and writing crontab files
      and accessing the system cron automatically and simply using a direct API.
    '';
    homepage = "https://pypi.org/project/python-crontab/";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ kfollesdal ];
  };
}
