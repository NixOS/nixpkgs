{ lib, buildPythonPackage, isPy3k, fetchPypi
, urllib3, python-dateutil , pytz, faker, mock, nose }:

buildPythonPackage rec {
  pname = "minio";
  version = "4.0.17";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fb1faab701008a1ff05b9b2497b6ba52d1aff963323356ed86f2771b186db6b";
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
