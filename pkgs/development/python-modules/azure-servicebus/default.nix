{ lib
, azure-common
, azure-core
, buildPythonPackage
, fetchPypi
, isodate
, msrestazure
, pythonOlder
, six
, typing-extensions
, uamqp
}:

buildPythonPackage rec {
  pname = "azure-servicebus";
  version = "7.8.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-FC4AUHWV8UxvB1Lz3/+z/l/OhdTj1YSn4iLmXt+zwZo=";
  };

  propagatedBuildInputs = [
    azure-common
    azure-core
    isodate
    msrestazure
    six
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
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
