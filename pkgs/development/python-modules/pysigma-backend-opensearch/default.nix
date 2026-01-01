{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pysigma,
  pysigma-backend-elasticsearch,
<<<<<<< HEAD
=======
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  requests,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "pysigma-backend-opensearch";
<<<<<<< HEAD
  version = "2.0.0";
  pyproject = true;

=======
  version = "1.0.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-backend-opensearch";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-N1Gs/L2kCcKkhHYXCyfmentvl1RORUrWIEyxTEsvNKg=";
=======
    hash = "sha256-VKDyXTvh0T/MKqsZo9lAlHyfhtiXzP5P+d0DSiLqS1o=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  pythonRelaxDeps = [ "pysigma" ];

  build-system = [ poetry-core ];

  dependencies = [
    pysigma
    pysigma-backend-elasticsearch
  ];

<<<<<<< HEAD
  # Starting with 2.0.0 all tests require network access
  doCheck = false;

  #pythonImportsCheck = [ "sigma.backends.opensearch" ];

  meta = {
    description = "Library to support OpenSearch for pySigma";
    homepage = "https://github.com/SigmaHQ/pySigma-backend-opensearch";
    changelog = "https://github.com/SigmaHQ/pySigma-backend-opensearch/releases/tag/${src.tag}";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ fab ];
=======
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

  meta = with lib; {
    description = "Library to support OpenSearch for pySigma";
    homepage = "https://github.com/SigmaHQ/pySigma-backend-opensearch";
    changelog = "https://github.com/SigmaHQ/pySigma-backend-opensearch/releases/tag/v${version}";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
