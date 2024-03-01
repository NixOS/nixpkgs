{ lib
, buildPythonPackage
, pythonAtLeast
, pythonOlder
, fetchPypi
, fetchpatch
, pytest
, pytest-asyncio
, pytestCheckHook
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pytest-mock";
  version = "3.11.1";

  disabled = pythonOlder "3.7";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-f2sSVgKsbXQ+Ujrgv6ceGml6L1U0BkUoxv+EwvfC/H8=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  buildInputs = [
    pytest
  ];

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
