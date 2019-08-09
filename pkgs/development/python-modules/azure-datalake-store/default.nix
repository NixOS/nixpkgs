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
  version = "0.0.45";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1k2wkpdv30wjmi53zdcsa5xfqw8gyak39na73ja6rb7wy8196wbd";
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
    homepage = https://docs.microsoft.com/en-us/python/api/overview/azure/data-lake-store?view=azure-python;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight ];
  };
}
