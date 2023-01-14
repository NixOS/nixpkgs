{ lib
, buildPythonPackage
, fetchPypi

# build
, pytest

# tests
, py
, pytestCheckHook
}:

let
  pname = "pytest-describe";
  version = "2.0.1";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5cuqMRafAGA0itXKAZECfl8fQfPyf97vIINl4JxV65o=";
  };

  buildInputs = [
    pytest
  ];

  checkInputs = [
    py
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Describe-style plugin for the pytest framework";
    homepage = "https://github.com/pytest-dev/pytest-describe";
    changelog = "https://github.com/pytest-dev/pytest-describe/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
