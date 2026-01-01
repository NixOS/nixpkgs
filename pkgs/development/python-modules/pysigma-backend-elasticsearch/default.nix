{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pysigma,
  pytest-cov-stub,
  pytestCheckHook,
<<<<<<< HEAD
  requests,
  writableTmpDirAsHomeHook,
=======
  pythonOlder,
  requests,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "pysigma-backend-elasticsearch";
<<<<<<< HEAD
  version = "2.0.0";
  pyproject = true;

=======
  version = "1.1.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-backend-elasticsearch";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-2gWYGu+Xr4R7QKEBiL5rXd/2HNinazyrF1OKzte0B3g=";
=======
    hash = "sha256-v+OTMcSvFXfjm4R3wCgLRCG0yKNqvY1mgRcmq2Jws0s=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ poetry-core ];

  dependencies = [ pysigma ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
    requests
<<<<<<< HEAD
    writableTmpDirAsHomeHook
  ];

  # Starting with 2.0.0 all tests require network access
  doCheck = false;

  #pythonImportsCheck = [ "sigma.backends.elasticsearch" ];

  meta = {
    description = "Library to support Elasticsearch for pySigma";
    homepage = "https://github.com/SigmaHQ/pySigma-backend-elasticsearch";
    changelog = "https://github.com/SigmaHQ/pySigma-backend-elasticsearch/releases/tag/${src.tag}";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ fab ];
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
