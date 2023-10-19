{ lib
, azure-common
, azure-core
, buildPythonPackage
, fetchPypi
, isodate
, msrest
, pythonOlder
, typing-extensions
, uamqp
}:

buildPythonPackage rec {
  pname = "azure-servicebus";
  version = "7.11.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lNZfL9yV56kSxT/qz4iH+w6QWGEmwBU+Ivrg+2UNH8o=";
  };

  propagatedBuildInputs = [
    azure-common
    azure-core
    isodate
    msrest
    typing-extensions
    uamqp
  ];

  # Tests require dev-tools
  doCheck = false;

  pythonImportsCheck = [
    "azure.servicebus"
  ];

  meta = with lib; {
    description = "Microsoft Azure Service Bus Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-servicebus_${version}/sdk/servicebus/azure-servicebus/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
