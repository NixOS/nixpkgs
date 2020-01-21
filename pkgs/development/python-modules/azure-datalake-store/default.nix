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
  version = "0.0.48";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d27c335783d4add00b3a5f709341e4a8009857440209e15a739a9a96b52386f7";
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
