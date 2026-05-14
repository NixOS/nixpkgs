{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pysigma,
  pysigma-backend-elasticsearch,
}:

buildPythonPackage (finalAttrs: {
  pname = "pysigma-backend-opensearch";
  version = "2.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SigmaHQ";
    repo = "pySigma-backend-opensearch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CCIQQeR/WXFV8A1elLxc4o32oox5wsOupI1XVjwFrUs=";
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
    changelog = "https://github.com/SigmaHQ/pySigma-backend-opensearch/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
