{ lib
, buildPythonPackage
, fetchPypi
, requests
, adal
, azure-common
, futures ? null
, pathlib2
, isPy3k
}:

buildPythonPackage rec {
  pname = "azure-datalake-store";
  version = "0.0.51";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b871ebb3bcfd292e8a062dbbaacbc132793d98f1b60f549a8c3b672619603fc1";
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
    maintainers = with maintainers; [ maxwilson ];
  };
}
