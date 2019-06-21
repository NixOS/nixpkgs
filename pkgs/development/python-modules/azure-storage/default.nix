{ buildAzurePythonPackage
, fetchPypi
, lib
, isPy3k
, python
, azure-common
, dateutil
, futures
, requests
}:

buildAzurePythonPackage rec {
  version = "0.36.0";
  pname = "azure-storage";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0pyasfxkin6j8j00qmky7d9cvpxgis4fi9bscgclj6yrpvf14qpv";
  };

  propagatedBuildInputs = [ azure-common dateutil requests ]
                            ++ lib.optionals (!isPy3k) [ futures ];

  # source package doesn't contain tests
  # github repo contains over 80 other azure namespace packages
  doCheck = false;

  meta = with lib; {
    description = "Microsoft Azure SDK for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ olcai jonringer ];
  };
}
