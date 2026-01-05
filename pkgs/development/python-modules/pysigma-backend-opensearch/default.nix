{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pysigma,
  pysigma-backend-elasticsearch,
}:

buildPythonPackage rec {
  pname = "pysigma-backend-opensearch";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-backend-opensearch";
    tag = "v${version}";
    hash = "sha256-N1Gs/L2kCcKkhHYXCyfmentvl1RORUrWIEyxTEsvNKg=";
  };

  pythonRelaxDeps = [ "pysigma" ];

  build-system = [ poetry-core ];

  dependencies = [
    pysigma
    pysigma-backend-elasticsearch
  ];

  # Starting with 2.0.0 all tests require network access
  doCheck = false;

  #pythonImportsCheck = [ "sigma.backends.opensearch" ];

  meta = {
    description = "Library to support OpenSearch for pySigma";
    homepage = "https://github.com/SigmaHQ/pySigma-backend-opensearch";
    changelog = "https://github.com/SigmaHQ/pySigma-backend-opensearch/releases/tag/${src.tag}";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
