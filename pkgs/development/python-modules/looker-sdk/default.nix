{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, attrs
, cattrs
, exceptiongroup
, pillow
, pytest-mock
, pyyaml
, requests
, typing-extensions
}:

buildPythonPackage rec {
  pname = "looker-sdk";
  version = "23.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "looker-open-source";
    repo = "sdk-codegen";
    rev = "sdk-v${version}";
    hash = "sha256-b34eH27hn3DdN3RwC+lz0dIxIRfIl5RnS9SfJnSP7NM=";
  };
  sourceRoot = "source/python";

  propagatedBuildInputs = [
    attrs
    cattrs
    exceptiongroup
    requests
    typing-extensions
  ];

  pythonImportsCheck = [
    "looker_sdk"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pillow
    pytest-mock
    pyyaml
  ];

  # disable tests that attempt to actually communicate with the api
  disabledTestPaths = [
    "tests/integration/test_methods.py"
    "tests/integration/test_netrc.py"
    "tests/rtl/test_api_methods.py"
  ];

  meta = with lib; {
    description = "Looker REST API SDK for Python";
    homepage = "https://github.com/looker-open-source/sdk-codegen/tree/main/python";
    changelog = "https://github.com/looker-open-source/sdk-codegen/blob/main/python/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
