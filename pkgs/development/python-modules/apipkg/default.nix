{ lib
, buildPythonPackage
, fetchFromGitHub
, hatch-vcs
, hatchling
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "apipkg";
  version = "3.0.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-gf84SzfuKLGYfI88IzPRJCqMZWwowUR10FgIbwXjwuY=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "test_apipkg.py"
  ];

  pythonImportsCheck = [
    "apipkg"
  ];

  meta = with lib; {
    changelog = "https://github.com/pytest-dev/apipkg/blob/main/CHANGELOG";
    description = "Namespace control and lazy-import mechanism";
    homepage = "https://github.com/pytest-dev/apipkg";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
