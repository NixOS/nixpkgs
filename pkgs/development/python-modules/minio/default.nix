{ lib, buildPythonPackage, isPy3k, fetchPypi
, urllib3, python-dateutil , pytz, faker, mock, nose }:

buildPythonPackage rec {
  pname = "minio";
  version = "5.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8f7ba1ca0750dfca3302cb03b14a92bf5f1c755ff84f9ba268079bf582e0f735";
  };

  disabled = !isPy3k;

  checkInputs = [ faker mock nose ];
  propagatedBuildInputs = [ urllib3 python-dateutil pytz ];

  meta = with lib; {
    description = "Simple APIs to access any Amazon S3 compatible object storage server";
    homepage = https://github.com/minio/minio-py;
    maintainers = with maintainers; [ peterromfeldhk ];
    license = licenses.asl20;
  };
}
