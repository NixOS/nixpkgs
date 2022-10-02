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
  version = "0.1.3";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-backend-opensearch";
    rev = "refs/tags/v${version}";
    hash = "sha256-lRw9zNyAIdwCT0uhZ9NxJXWs+sB/cyGFtZIIBImTNcM=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    pysigma
    pysigma-backend-elasticsearch
  ];

  checkInputs = [
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
    license = with licenses; [ lgpl21Only ];
    maintainers = with maintainers; [ fab ];
  };
}
