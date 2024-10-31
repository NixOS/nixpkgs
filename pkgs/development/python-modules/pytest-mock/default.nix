{
  lib,
  buildPythonPackage,
  pythonAtLeast,
  pythonOlder,
  fetchPypi,
  pytest,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pytest-mock";
  version = "3.14.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JxklWh7+zq28BW1r8989HFAVUw+0DPNHwPmvrIhBC9A=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.11") [
    # Regression in 3.11.7 and 3.12.1; https://github.com/pytest-dev/pytest-mock/issues/401
    "test_failure_message_with_name"
    "test_failure_message_with_no_name"
  ];

  pythonImportsCheck = [ "pytest_mock" ];

  meta = with lib; {
    description = "Thin wrapper around the mock package for easier use with pytest";
    homepage = "https://github.com/pytest-dev/pytest-mock";
    changelog = "https://github.com/pytest-dev/pytest-mock/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
