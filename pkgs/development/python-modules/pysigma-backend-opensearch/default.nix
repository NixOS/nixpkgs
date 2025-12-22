{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pysigma,
  pysigma-backend-elasticsearch,
  pytest-cov-stub,
  pytestCheckHook,
  requests,
}:

buildPythonPackage rec {
  pname = "pysigma-backend-opensearch";
  version = "1.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-backend-opensearch";
    tag = "v${version}";
    hash = "sha256-VKDyXTvh0T/MKqsZo9lAlHyfhtiXzP5P+d0DSiLqS1o=";
  };

  pythonRelaxDeps = [ "pysigma" ];

  build-system = [ poetry-core ];

  dependencies = [
    pysigma
    pysigma-backend-elasticsearch
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
    requests
  ];

  pythonImportsCheck = [ "sigma.backends.opensearch" ];

  disabledTests = [
    # Tests requires network access
    "test_connect_lucene"
  ];

  meta = {
    description = "Library to support OpenSearch for pySigma";
    homepage = "https://github.com/SigmaHQ/pySigma-backend-opensearch";
    changelog = "https://github.com/SigmaHQ/pySigma-backend-opensearch/releases/tag/${src.tag}";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
