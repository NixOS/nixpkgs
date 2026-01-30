{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-redis";
  version = "14.5.0";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "azure_mgmt_redis";
    hash = "sha256-XDQ0yCSSaI4luTqvURPs/wuSt61toqT9RpVTD4KxUvo=";
  };

  propagatedBuildInputs = [
    isodate
    azure-common
    azure-mgmt-core
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.redis" ];

  meta = {
    description = "This is the Microsoft Azure Redis Cache Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-redis_${version}/sdk/redis/azure-mgmt-redis/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxwilson ];
  };
}
