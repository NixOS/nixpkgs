{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-dns";
  version = "9.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "azure_mgmt_dns";
    inherit version;
    hash = "sha256-ifjE5GepQiS5e/Ft121b1ha/Ec7+cn93ZhilfMVIbjc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-mgmt-core
    isodate
    typing-extensions
  ];

  # this is still needed for when the version is overrided
  pythonNamespaces = [ "azure.mgmt" ];

  # Tests are only available in the mono-repo
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure DNS Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/network/azure-mgmt-dns";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-dns_${version}/sdk/network/azure-mgmt-dns/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
