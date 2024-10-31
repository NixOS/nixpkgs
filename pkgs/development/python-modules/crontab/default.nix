{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  python-dateutil,
  pytz,
  setuptools,
}:

buildPythonPackage rec {
  pname = "crontab";
  version = "0.23.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "josiahcarlson";
    repo = "parse-crontab";
    rev = "refs/tags/${version}";
    hash = "sha256-8vMkgBU1jIluo9+hAvk2KNM+Wn0+PvJqFNwX+JLXD+w=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    python-dateutil
    pytz
  ];

  pythonImportsCheck = [ "crontab" ];

  meta = with lib; {
    description = "Parse and use crontab schedules in Python";
    homepage = "https://github.com/josiahcarlson/parse-crontab";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ fab ];
  };
}
