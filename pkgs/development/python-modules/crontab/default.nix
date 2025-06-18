{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  pytestCheckHook,
  pythonOlder,
  python-dateutil,
  pytz,
  setuptools,
}:

buildPythonPackage rec {
  pname = "crontab";
  version = "3.2.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitLab {
    owner = "doctormo";
    repo = "python-crontab";
    rev = "refs/tags/v${version}";
    hash = "sha256-OZalqh/A4pBM1Hat4t76Odk2cTmKLwaHGY7pndgIgss=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    python-dateutil
    pytz
  ];

  pythonImportsCheck = [ "crontab" ];

  meta = with lib; {
    description = "Parse and use crontab schedules in Python";
    homepage = "https://gitlab.com/doctormo/python-crontab/";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ fab ];
  };
}
