{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, pytest
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pytest-subtests";
  version = "0.11.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UYZciEV1RfUftyARlC8KPGkB7p4ky/ttG53BNIuvvjc=";
  };

  buildInputs = [
    pytest
  ];

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsExtrasCheck = [
    "pytest_subtests"
  ];

  meta = with lib; {
    description = "Pytest plugin for unittest subTest() support and subtests fixture";
    homepage = "https://github.com/pytest-dev/pytest-subtests";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
