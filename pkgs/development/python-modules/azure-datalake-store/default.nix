{ lib, buildAzurePythonPackage, fetchPypi, python, isPy27
, cffi
, adal
, requests
, pathlib2
, futures
, azure-nspkg
}:

buildAzurePythonPackage rec {
  version = "0.0.46";
  pname = "azure-datalake-store";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0hw5nlx77h2c3sis6bvlsplc311b63jzn9mr7bh2864a23p61iav";
  };

  propagatedBuildInputs = [ cffi adal requests ]
    ++ lib.optionals isPy27 [ pathlib2 futures azure-nspkg ];

  # These tests require a provisioned azure-datalake-store service
  doCheck = false;

  meta = with lib; {
    description = "This project is the Python filesystem library for Azure Data Lake Store";
    homepage = https://docs.microsoft.com/en-us/python/api/overview/azure/data-lake-store?view=azure-python;
    license = licenses.mit;
    maintainers = with maintainers; [ mwilsoninsight jonringer ];
  };
}
