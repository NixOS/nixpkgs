{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  pytestCheckHook,
  python-dateutil,
  pytz,
  setuptools,
}:

buildPythonPackage rec {
  pname = "crontab";
  version = "3.3.0";
  pyproject = true;

  src = fetchFromGitLab {
    owner = "doctormo";
    repo = "python-crontab";
    tag = "v${version}";
    hash = "sha256-eJXtvTRwokbewWrTArHJ2FXGDLvlkGA/5ZZR01koMW8=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    python-dateutil
    pytz
  ];

  pythonImportsCheck = [ "crontab" ];

  meta = {
    description = "Parse and use crontab schedules in Python";
    homepage = "https://gitlab.com/doctormo/python-crontab/";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
