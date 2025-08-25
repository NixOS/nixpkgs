{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  msrest,
  azure-common,
  azure-mgmt-core,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-media";
  version = "10.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-TVq/6dHttDGIUFzn8KTVeDTwcBMmphz3zrsGK7ux4aU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    msrest
    azure-common
    azure-mgmt-core
    typing-extensions
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.media" ];

  meta = {
    description = "This is the Microsoft Azure Media Services Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxwilson ];
  };
}
