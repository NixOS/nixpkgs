{ lib
, buildPythonPackage
, fetchPypi
, uamqp
, azure-common
, azure-core
, msrestazure
, futures ? null
, isPy3k
}:

buildPythonPackage rec {
  pname = "azure-servicebus";
  version = "7.3.3";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "1c2133909a086bd4329135d6affcc05628e3a7da27afca584a0de8c21fc4e1ac";
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
    description = "Microsoft Azure Service Bus Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
