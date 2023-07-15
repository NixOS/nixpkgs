{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, python-dateutil
, pythonOlder
, pytz
, tzlocal
}:

buildPythonPackage rec {
  pname = "croniter";
  version = "1.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Gm32DqzsO3oKpSqPLvJRrj3Sp8fIuYdOc+eRY21Vo2E=";
  };

  propagatedBuildInputs = [
    python-dateutil
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytz
    tzlocal
  ];

  pythonImportsCheck = [
    "croniter"
  ];

  meta = with lib; {
    description = "Library to iterate over datetime object with cron like format";
    homepage = "https://github.com/kiorky/croniter";
    changelog = "https://github.com/kiorky/croniter/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
