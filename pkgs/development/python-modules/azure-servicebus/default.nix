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
  version = "7.0.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "875527251c1fed99fcb90597c6abb7daa4bc0ed88e080b4c36f897b704668450";
  };

  buildInputs = [
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
