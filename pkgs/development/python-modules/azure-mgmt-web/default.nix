{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-web";
  version = "9.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_web";
    inherit version;
    hash = "sha256-RFXs07SYV3CFwZBObRcTklTjWLoH/mxINaiRu697BsI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-mgmt-core
    isodate
    typing-extensions
  ];

  # has no tests
  doCheck = false;

  meta = {
    description = "This is the Microsoft Azure Web Apps Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-web_${version}/sdk/appservice/azure-mgmt-web/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxwilson ];
  };
}
