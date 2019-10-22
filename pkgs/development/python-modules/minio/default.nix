{ lib, buildPythonPackage, isPy3k, fetchPypi
, urllib3, python-dateutil , pytz, faker, mock, nose, future }:

buildPythonPackage rec {
  pname = "minio";
  version = "5.0.1";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0dgpw21gb6q7d2i9nkzqbxsiqpxzj95b20yb08rwmpsh0z5a2ywg";
  };

  propagatedBuildInputs = [ future urllib3 python-dateutil pytz ];
  checkInputs = [ faker mock nose ];

  meta = with lib; {
    description = "Simple APIs to access any Amazon S3 compatible object storage server";
    homepage = https://github.com/minio/minio-py;
    maintainers = with maintainers; [ peterromfeldhk ];
    license = licenses.asl20;
  };
}
