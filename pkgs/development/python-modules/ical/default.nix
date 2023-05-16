{ lib
, python-dateutil
, buildPythonPackage
, emoji
, fetchFromGitHub
, freezegun
, tzdata
<<<<<<< HEAD
=======
, py
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pyparsing
, pydantic
, pytest-asyncio
, pytest-benchmark
, pytest-golden
, pytestCheckHook
, pythonOlder
<<<<<<< HEAD
, pythonRelaxDepsHook
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pyyaml
}:

buildPythonPackage rec {
  pname = "ical";
<<<<<<< HEAD
  version = "5.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.10";
=======
  version = "4.5.3";
  format = "setuptools";

  disabled = pythonOlder "3.9";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-6gMmY6XlFdqF0DxkrCJhZPzUYZuEpDnIHG++nBRE3hg=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "tzdata"
  ];

=======
    hash = "sha256-CHo6khJ8Bqej/OdQBtcfa/luO1Gj8cu7h//MwPhWrMU=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  propagatedBuildInputs = [
    emoji
    python-dateutil
    tzdata
    pydantic
    pyparsing
  ];

  nativeCheckInputs = [
    freezegun
<<<<<<< HEAD
=======
    py
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pytest-asyncio
    pytest-benchmark
    pytest-golden
    pytestCheckHook
    pyyaml
  ];

  pythonImportsCheck = [
    "ical"
  ];

  meta = with lib; {
    description = "Library for handling iCalendar";
    homepage = "https://github.com/allenporter/ical";
    changelog = "https://github.com/allenporter/ical/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
