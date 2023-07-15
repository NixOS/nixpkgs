{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, hatch-vcs
, hatchling
, wcwidth
, importlib-metadata
, pytest-lazy-fixture
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "prettytable";
  version = "3.5.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "prettytable";
    rev = "refs/tags/${version}";
    hash= "sha256-J6oWNug2MEkUZSi67mM5H/Nf4tdSTB/ku34plp1XWCM=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    wcwidth
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  nativeCheckInputs = [
    pytest-lazy-fixture
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "prettytable"
  ];

  meta = with lib; {
    changelog = "https://github.com/jazzband/prettytable/releases/tag/${version}";
    description = "Display tabular data in a visually appealing ASCII table format";
    homepage = "https://github.com/jazzband/prettytable";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };

}
