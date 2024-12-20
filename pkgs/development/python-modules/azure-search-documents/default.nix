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
  version = "11.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-sdk-for-python";
    rev = "azure-search-documents_${version}";
    hash = "sha256-0J9AXDH7TOkcKDwFbICiMatLAwiFq3Jtoji8fJSOg8k=";
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
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/${src.rev}/sdk/search/azure-search-documents/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
