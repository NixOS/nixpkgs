{ lib
, buildPythonPackage
, fetchPypi
, hatchling
, hatch-vcs
, pytest
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytest-repeat";
  version = "0.9.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "pytest_repeat";
    inherit version;
    hash = "sha256-/9ODbfzWe7JwvsZIszDiC+N9KWZEjEFIxAktHoq6gYU=";
  };

  nativeBuildInputs = [
    hatchling
    hatch-vcs
  ];

  buildInputs = [
    pytest
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pytest_repeat"
  ];

  meta = with lib; {
    description = "Pytest plugin for repeating tests";
    homepage = "https://github.com/pytest-dev/pytest-repeat";
    changelog = "https://github.com/pytest-dev/pytest-repeat/blob/v${version}/CHANGES.rst";
    license = licenses.mpl20;
    maintainers = with maintainers; [ ];
  };
}
