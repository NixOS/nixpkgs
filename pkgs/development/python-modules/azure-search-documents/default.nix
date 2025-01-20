{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  azure-common,
  azure-core,
  isodate,
}:

buildPythonPackage rec {
  pname = "azure-search-documents";
  version = "33.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-sdk-for-python";
    tag = "azure-mgmt-compute_${version}";
    hash = "sha256-Lrr2LMvr7xHOq+bJOUMwO6sY6X+a0MLvdD2P8L166iM=";
  };

  sourceRoot = "${src.name}/sdk/search/azure-search-documents";

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-core
    isodate
  ];

  pythonImportsCheck = [ "azure.search.documents" ];

  # require devtools_testutils which is a internal package for azure-sdk
  doCheck = false;

  meta = {
    description = "Microsoft Azure Cognitive Search Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/search/azure-search-documents";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/${src.tag}/sdk/search/azure-search-documents/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
