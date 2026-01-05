{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pysigma,
  pytest-cov-stub,
  pytestCheckHook,
  requests,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "pysigma-backend-elasticsearch";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-backend-elasticsearch";
    tag = "v${version}";
    hash = "sha256-2gWYGu+Xr4R7QKEBiL5rXd/2HNinazyrF1OKzte0B3g=";
  };

  build-system = [ poetry-core ];

  dependencies = [ pysigma ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
    requests
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
  };
}
