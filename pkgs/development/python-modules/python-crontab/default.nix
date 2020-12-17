{ lib, buildPythonPackage, fetchPypi, python-dateutil, pytestCheckHook }:

buildPythonPackage rec {
  pname = "python-crontab";
  version = "2.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4bbe7e720753a132ca4ca9d4094915f40e9d9dc8a807a4564007651018ce8c31";
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
