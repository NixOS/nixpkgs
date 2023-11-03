{ lib
, buildPythonPackage
, convertdate
, fetchFromGitHub
, hijri-converter
, importlib-metadata
, korean-lunar-calendar
, polib
, pytestCheckHook
, python-dateutil
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "holidays";
  version = "0.35";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "dr-prodigy";
    repo = "python-holidays";
    rev = "refs/tags/v${version}";
    hash = "sha256-FrAqVLyEtjhpiu1XdFY5yOstKKjXhRTv9PeaFlJaf8k=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    convertdate
    python-dateutil
    hijri-converter
    korean-lunar-calendar
  ];

  nativeCheckInputs = [
    importlib-metadata
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
    changelog = "https://github.com/dr-prodigy/python-holidays/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab jluttine ];
  };
}

