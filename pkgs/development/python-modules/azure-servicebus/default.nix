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
  version = "7.3.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "sha256-NigQxqZjekZjlu6wSrziVwbEBclxfwSK4svd0eHPKr8=";
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
