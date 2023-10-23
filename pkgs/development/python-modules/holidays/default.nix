{ lib
, buildPythonPackage
, convertdate
, fetchFromGitHub
, hijri-converter
, korean-lunar-calendar
, polib
, pytestCheckHook
, python-dateutil
, pythonOlder
}:

buildPythonPackage rec {
  pname = "holidays";
  version = "0.32";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "dr-prodigy";
    repo = "python-holidays";
    rev = "refs/tags/v.${version}";
    hash = "sha256-YAh5gR4KcUgXzeXy3xyGeokDFsyd9FqRQ5j1TC6wCQY=";
  };

  propagatedBuildInputs = [
    convertdate
    python-dateutil
    hijri-converter
    korean-lunar-calendar
  ];

  nativeCheckInputs = [
    polib
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

