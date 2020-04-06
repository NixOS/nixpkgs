{ lib, buildPythonPackage, isPy3k, fetchPypi
, urllib3, future, python-dateutil , pytz, faker, mock, nose }:

buildPythonPackage rec {
  pname = "minio";
  version = "5.0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1p6gnbapwzpg7h0wv52fn4dd3dlhxl5qziadkiqjl8xaz8yp3vys";
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
