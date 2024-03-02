{ lib
, buildPythonPackage
, fetchPypi
, hatch-vcs
, hatchling
, pytest
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytest-metadata";
  version = "3.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "pytest_metadata";
    inherit version;
    hash = "sha256-dpqcZdKIS9WDvGJrCs53rRXb4C3ZGpEG1H/UbZwlaco=";
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

  meta = with lib; {
    description = "Plugin for accessing test session metadata";
    homepage = "https://github.com/pytest-dev/pytest-metadata";
    license = licenses.mpl20;
    maintainers = with maintainers; [ mpoquet ];
  };
}
