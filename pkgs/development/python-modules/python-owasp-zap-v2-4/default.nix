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

buildPythonPackage (finalAttrs: {
  pname = "python-owasp-zap-v2-4";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zaproxy";
    repo = "zap-api-python";
    tag = finalAttrs.version;
    hash = "sha256-a0F6asx8Dl1T/OqNhHukHRbq+LUqsl3im+y1k096pfE=";
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
})
