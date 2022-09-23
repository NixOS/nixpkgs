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
  version = "0.1.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-backend-opensearch";
    rev = "v${version}";
    hash = "sha256-5+/LOi7GHu8h9WhjpZ7bBc4aM41NiXrSrdGhbXdYMvw=";
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
