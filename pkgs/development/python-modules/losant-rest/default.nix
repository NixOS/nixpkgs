{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  requests,
  requests-mock,
  setuptools,
}:

buildPythonPackage rec {
  pname = "losant-rest";
  version = "1.22.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Losant";
    repo = "losant-rest-python";
    tag = "v${version}";
    hash = "sha256-7H7jmNsz5UTcM0i1KiVwQb2UMlLRQ/3W2rhM79+Q4Es=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  enabledTestPaths = [ "tests/platformrest_tests.py" ];

  pythonImportsCheck = [ "platformrest" ];

  meta = with lib; {
    description = "Python module for consuming the Losant IoT Platform API";
    homepage = "https://github.com/Losant/losant-rest-python";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
