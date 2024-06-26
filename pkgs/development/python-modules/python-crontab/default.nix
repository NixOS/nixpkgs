{
  lib,
  buildPythonPackage,
  fetchPypi,
  python-dateutil,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-crontab";
  version = "3.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9OoWBdJFM7Z/p6Y07ybLWaXy55VPbmd9LXoiKZWaL8g=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ python-dateutil ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    "test_07_non_posix_shell"
    # doctest that assumes /tmp is writeable, awkward to patch
    "test_03_usage"
    # Test is assuming $CURRENT_YEAR is not a leap year
    "test_19_frequency_at_month"
    "test_20_frequency_at_year"
  ];

  pythonImportsCheck = [ "crontab" ];

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
