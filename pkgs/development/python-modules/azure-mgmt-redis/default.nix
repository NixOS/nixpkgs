{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  pythonOlder,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-redis";
  version = "14.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eoMbY4oNzYXkn3uFUhxecJQD+BxYkGTbWhAWSgAoLyA=";
  };

  propagatedBuildInputs = [
    isodate
    azure-common
    azure-mgmt-core
  ] ++ lib.optionals (pythonOlder "3.8") [ typing-extensions ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.redis" ];

  meta = with lib; {
    description = "This is the Microsoft Azure Redis Cache Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-redis_${version}/sdk/redis/azure-mgmt-redis/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
