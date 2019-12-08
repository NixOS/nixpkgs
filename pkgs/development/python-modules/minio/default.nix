{ lib, buildPythonPackage, isPy3k, fetchPypi
, urllib3, future, python-dateutil , pytz, faker, mock, nose }:

buildPythonPackage rec {
  pname = "minio";
  version = "5.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a5886b3ccb9b46cb4a322a486e06674d1f287b773f20b24cdc3de8450ff935a7";
  };

  disabled = !isPy3k;

  checkInputs = [ faker mock nose ];
  propagatedBuildInputs = [ urllib3 python-dateutil pytz future ];

  meta = with lib; {
    description = "Simple APIs to access any Amazon S3 compatible object storage server";
    homepage = https://github.com/minio/minio-py;
    maintainers = with maintainers; [ peterromfeldhk ];
    license = licenses.asl20;
  };
}
