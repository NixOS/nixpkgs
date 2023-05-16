{ lib
, buildPythonPackage
, convertdate
, fetchFromGitHub
, hijri-converter
, korean-lunar-calendar
, pytestCheckHook
, python-dateutil
, pythonOlder
}:

buildPythonPackage rec {
  pname = "holidays";
<<<<<<< HEAD
  version = "0.29";
  format = "setuptools";

  disabled = pythonOlder "3.8";
=======
  version = "0.24";
  format = "setuptools";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "dr-prodigy";
    repo = "python-holidays";
    rev = "refs/tags/v.${version}";
<<<<<<< HEAD
    hash = "sha256-ijhqu0LzQzpjDSe9ZjNhgdjq/DJuD7oVbRTLX97nGHM=";
=======
    hash = "sha256-1/rphnbzDlbay+yez/erF+WC+2aqeBEgdcHo2YR+ugc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    convertdate
    python-dateutil
    hijri-converter
    korean-lunar-calendar
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "holidays"
  ];

  disabledTests = [
    # Failure starting with 0.24
    "test_l10n"
  ];

  meta = with lib; {
    description = "Generate and work with holidays in Python";
    homepage = "https://github.com/dr-prodigy/python-holidays";
    changelog = "https://github.com/dr-prodigy/python-holidays/releases/tag/v.${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}

