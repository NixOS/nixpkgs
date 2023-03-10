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
  version = "0.20";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "dr-prodigy";
    repo = "python-holidays";
    rev = "refs/tags/v.${version}";
    hash = "sha256-hz0v4g94RMA1dKOLu4BSYnK5EPNl1hIWEShFJWO0F3A=";
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

  meta = with lib; {
    description = "Generate and work with holidays in Python";
    homepage = "https://github.com/dr-prodigy/python-holidays";
    changelog = "https://github.com/dr-prodigy/python-holidays/releases/tag/v.${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
