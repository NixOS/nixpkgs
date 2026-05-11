{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pyhamcrest,
  pytestCheckHook,
  requests,
  requests-mock,
  six,
}:

buildPythonPackage rec {
  pname = "python-owasp-zap-v2-4";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zaproxy";
    repo = "zap-api-python";
    tag = version;
    hash = "sha256-8aZbnUoS9lrqM0XQg4PD/j1JFKzGh9dyzWF89Szdzao=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    requests
    six
  ];

  nativeCheckInputs = [
    pyhamcrest
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "zapv2" ];

  meta = {
    description = "Python library to access the OWASP ZAP API";
    homepage = "https://github.com/zaproxy/zap-api-python";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
