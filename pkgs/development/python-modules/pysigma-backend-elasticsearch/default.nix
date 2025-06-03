{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pysigma,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "pysigma-backend-elasticsearch";
  version = "1.1.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-backend-elasticsearch";
    tag = "v${version}";
    hash = "sha256-v+OTMcSvFXfjm4R3wCgLRCG0yKNqvY1mgRcmq2Jws0s=";
  };

  build-system = [ poetry-core ];

  dependencies = [ pysigma ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
    requests
  ];

  pythonImportsCheck = [ "sigma.backends.elasticsearch" ];

  disabledTests = [
    # Tests requires network access
    "test_connect_lucene"
    # AssertionError
    "correlation_rule_stats"
  ];

  meta = with lib; {
    description = "Library to support Elasticsearch for pySigma";
    homepage = "https://github.com/SigmaHQ/pySigma-backend-elasticsearch";
    changelog = "https://github.com/SigmaHQ/pySigma-backend-elasticsearch/releases/tag/v${version}";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ fab ];
  };
}
