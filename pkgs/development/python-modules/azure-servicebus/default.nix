{ lib
, buildPythonPackage
, fetchPypi
, uamqp
, azure-common
, azure-core
, msrestazure
, futures
, isPy3k
}:

buildPythonPackage rec {
  pname = "azure-servicebus";
  version = "7.0.1";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "46d1e7b9da537da831c3184d42d3e2bc3c7ab9234e204a9d4c2e5dc54010721b";
  };

  propagatedBuildInputs = [
    uamqp
    azure-common
    azure-core
    msrestazure
  ] ++ lib.optionals (!isPy3k) [
    futures
  ];

  # has no tests
  doCheck = false;

  # python2 will fail due to pep 420
  pythonImportsCheck = lib.optionals isPy3k [ "azure.servicebus" ];

  meta = with lib; {
    description = "This is the Microsoft Azure Service Bus Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
