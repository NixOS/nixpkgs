{ lib
, buildPythonPackage
, fetchFromGitHub
, hatch-vcs
, hatchling
, pytest-lazy-fixture
, pytestCheckHook
, pythonOlder
, wcwidth
}:

buildPythonPackage rec {
  pname = "prettytable";
  version = "3.9.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "prettytable";
    rev = "refs/tags/${version}";
    hash= "sha256-yIO4eO2VdOnUt9qoNQOeq/c0os2LQ3mqAkCOIuoGpyg=";
  };

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    wcwidth
  ];

  nativeCheckInputs = [
    pytest-lazy-fixture
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "prettytable"
  ];

  meta = with lib; {
    description = "Display tabular data in a visually appealing ASCII table format";
    homepage = "https://github.com/jazzband/prettytable";
    changelog = "https://github.com/jazzband/prettytable/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };

}
