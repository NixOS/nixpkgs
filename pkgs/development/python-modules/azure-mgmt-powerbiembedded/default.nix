{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-powerbiembedded";
  version = "3.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yz2D3WfQKEdkTm10ZKIhZMi4y6GF6yz+L1+nB/VFofo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-mgmt-core
    isodate
  ];

  # Module has only tests in mono-repo
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Power BI Embedded Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/powerbiembedded/azure-mgmt-powerbiembedded";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-powerbiembedded_${version}/sdk/powerbiembedded/azure-mgmt-powerbiembedded/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
