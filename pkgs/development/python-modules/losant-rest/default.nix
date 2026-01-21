{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  requests,
  requests-mock,
  setuptools,
}:

buildPythonPackage rec {
  pname = "losant-rest";
  version = "2.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Losant";
    repo = "losant-rest-python";
    tag = "v${version}";
    hash = "sha256-B4r3ZCXt3jC/8vtBzct1HEBuMq9NpF2qOlmlhZk9a3Q=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  enabledTestPaths = [ "tests/platformrest_tests.py" ];

  pythonImportsCheck = [ "platformrest" ];

  meta = {
    description = "Python module for consuming the Losant IoT Platform API";
    homepage = "https://github.com/Losant/losant-rest-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
