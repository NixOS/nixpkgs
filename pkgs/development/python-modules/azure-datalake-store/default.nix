{ lib
, buildPythonPackage
, fetchPypi
, requests
, adal
, azure-common
, futures
, pathlib2
, isPy3k
}:

buildPythonPackage rec {
  pname = "azure-datalake-store";
  version = "0.0.49";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3fcede6255cc9cd083d498c3a399b422f35f804c561bb369a7150ff1f2f07da9";
  };

  propagatedBuildInputs = [
    requests
    adal
    azure-common
  ] ++ lib.optionals (!isPy3k) [
    futures
    pathlib2
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This project is the Python filesystem library for Azure Data Lake Store";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
