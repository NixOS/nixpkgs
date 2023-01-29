{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pysigma
, pysigma-backend-elasticsearch
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "pysigma-backend-opensearch";
  version = "0.1.5";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-backend-opensearch";
    rev = "refs/tags/v${version}";
    hash = "sha256-j8BiO/7wp1TRSK+C5cPSgF72CuBpb2jLhJXRJLHgh5I=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pysigma
    pysigma-backend-elasticsearch
  ];

  nativeCheckInputs = [
    pytestCheckHook
    requests
  ];

  pythonImportsCheck = [
    "sigma.backends.opensearch"
  ];

  disabledTests = [
    # Tests requires network access
    "test_connect_lucene"
  ];

  meta = with lib; {
    description = "Library to support OpenSearch for pySigma";
    homepage = "https://github.com/SigmaHQ/pySigma-backend-opensearch";
    changelog = "https://github.com/SigmaHQ/pySigma-backend-opensearch/releases/tag/v${version}";
    license = with licenses; [ lgpl21Only ];
    maintainers = with maintainers; [ fab ];
  };
}
