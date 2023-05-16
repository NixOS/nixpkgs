{ lib
, buildPythonPackage
, fetchPypi
<<<<<<< HEAD
, pytestCheckHook
, python-dateutil
, pythonOlder
=======
, python-dateutil
, pytestCheckHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pytz
, tzlocal
}:

buildPythonPackage rec {
  pname = "croniter";
<<<<<<< HEAD
  version = "1.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Gm32DqzsO3oKpSqPLvJRrj3Sp8fIuYdOc+eRY21Vo2E=";
=======
  version = "1.3.8";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MqXsBOl+wIN7zfATdnq9LnHM7u/TwuFMgECYzlGtbNk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    changelog = "https://github.com/kiorky/croniter/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
=======
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
