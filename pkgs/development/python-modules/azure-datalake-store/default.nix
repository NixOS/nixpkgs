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
  version = "0.0.52";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4198ddb32614d16d4502b43d5c9739f81432b7e0e4d75d30e05149fe6007fea2";
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
