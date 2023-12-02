{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pytestCheckHook
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pytest-repeat";
  version = "0.9.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/9ODbfzWe7JwvsZIszDiC+N9KWZEjEFIxAktHoq6gYU=";
  };

  nativeBuildInputs = [
    setuptools-scm
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
