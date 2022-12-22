{ lib, buildPythonPackage, fetchPypi, python-dateutil, pytestCheckHook }:

buildPythonPackage rec {
  pname = "python-crontab";
  version = "2.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-shr0ZHx7u4SP7y8CBhbGsCidy5+UtPmRpVMQ/5vsV0k=";
  };

  checkInputs = [ pytestCheckHook ];
  disabledTests = [
    "test_07_non_posix_shell"
    # doctest that assumes /tmp is writeable, awkward to patch
    "test_03_usage"
  ];

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
