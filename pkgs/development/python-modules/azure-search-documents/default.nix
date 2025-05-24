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
  version = "36.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Azure";
    repo = "azure-sdk-for-python";
    tag = "azure-mgmt-containerservice_${version}";
    hash = "sha256-MnutSwx4mNDR9ofIRkAx6qJy0UH18+F9BY5oOn46tR0=";
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

  # multiple packages in the repo and the updater picks the wrong tag
  passthru.skipBulkUpdate = true;

  meta = {
    description = "Microsoft Azure Cognitive Search Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/search/azure-search-documents";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/${src.tag}/sdk/search/azure-search-documents/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
  };
}
