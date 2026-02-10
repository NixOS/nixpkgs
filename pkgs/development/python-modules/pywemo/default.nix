{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  hypothesis,
  ifaddr,
  lxml,
  poetry-core,
  pytest-vcr,
  pytestCheckHook,
  requests,
  urllib3,
}:

buildPythonPackage (finalAttrs: {
  pname = "pywemo";
  version = "2.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pywemo";
    repo = "pywemo";
    tag = finalAttrs.version;
    hash = "sha256-IyUahdExD6YNl4vG/bogiLlO8JaRUEslmc5/ZAUMomQ=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    cryptography
    ifaddr
    lxml
    requests
    urllib3
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    hypothesis
    pytest-vcr
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pywemo" ];

  meta = {
    description = "Python module to discover and control WeMo devices";
    homepage = "https://github.com/pywemo/pywemo";
    changelog = "https://github.com/pywemo/pywemo/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
