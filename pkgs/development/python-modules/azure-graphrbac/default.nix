{
  lib,
  buildPythonPackage,
  fetchPypi,
  msrest,
  msrestazure,
  azure-common,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-graphrbac";
  version = "0.61.2";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_graphrbac";
    inherit version;
    hash = "sha256-+yWwMwfhf3Ocga1r0+m1fFeENoYDHw8hS2UVhEfHc90=";
  };

  build-system = [ setuptools ];

  dependencies = [
    msrest
    msrestazure
    azure-common
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Graph RBAC Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/graphrbac/azure-graphrbac";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-graphrbac_${version}/sdk/graphrbac/azure-graphrbac/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
