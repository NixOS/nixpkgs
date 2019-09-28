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
  version = "0.0.47";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19fkkabr76r851r95kh5dpk4bdn3jkysv3aij6i2x99mkb4vxg2m";
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
