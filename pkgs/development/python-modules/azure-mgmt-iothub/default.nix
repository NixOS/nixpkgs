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
  pname = "azure-mgmt-iothub";
  version = "3.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2vIfyYxoo1PsYWMYwOYr4EyNaJmWC+jCy/mRZzrItyI=";
  };

  propagatedBuildInputs = [
    azure-common
    azure-mgmt-core
    isodate
  ] ++ lib.optionals (pythonOlder "3.8") [ typing-extensions ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.iothub" ];

  meta = with lib; {
    description = "This is the Microsoft Azure IoTHub Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-iothub_${version}/sdk/iothub/azure-mgmt-iothub/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
