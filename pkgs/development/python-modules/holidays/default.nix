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
  version = "0.33";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "dr-prodigy";
    repo = "python-holidays";
    rev = "refs/tags/v.${version}";
    hash = "sha256-KX0jJJiAEn3Z7bjxuUtvj0rgkYSDLpQyIYHHett8AUU=";
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
    # Localization-related tests need some work
    "test_add_countries"
    "test_copy"
    "test_eq"
    "test_get_list"
    "test_l10n"
    "test_ne"
    "test_populate_substituted_holidays"
  ];

  meta = with lib; {
    description = "Generate and work with holidays in Python";
    homepage = "https://github.com/dr-prodigy/python-holidays";
    changelog = "https://github.com/dr-prodigy/python-holidays/releases/tag/v.${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab jluttine ];
  };
}

