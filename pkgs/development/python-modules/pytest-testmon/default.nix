{ lib
, buildPythonPackage
, coverage
, fetchFromGitHub
, poetry-core
, pytest
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "pytest-testmon";
  version = "2.0.9";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tarpas";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-klKn110zmurLx3aITYiGV1tLztTiY/Z2tf/L6qW2cGI=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    coverage
  ];

  # The project does not include tests since version 1.3.0
  doCheck = false;

  pythonImportsCheck = [
    "testmon"
  ];

  meta = with lib; {
    description = "Pytest plug-in which automatically selects and re-executes only tests affected by recent changes";
    homepage = "https://github.com/tarpas/pytest-testmon/";
    changelog = "https://github.com/tarpas/pytest-testmon/releases/tag/v${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ dmvianna ];
  };
}
