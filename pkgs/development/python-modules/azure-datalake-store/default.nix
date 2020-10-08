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
  version = "0.0.50";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9b9b58dcf1d0d0e5aa499d5cb49dcf8f5432ca467a747b39167bb70ef901dbc2";
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
