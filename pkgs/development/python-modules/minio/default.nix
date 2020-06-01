{ lib, buildPythonPackage, isPy3k, fetchPypi
, urllib3, future, python-dateutil , pytz, faker, mock, nose }:

buildPythonPackage rec {
  pname = "minio";
  version = "5.0.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6ecb7637a35f806733e9d112eacfa599a58d7c3d4698fda2b5c86fff5d34b417";
  };

  disabled = !isPy3k;

  checkInputs = [ faker mock nose ];
  propagatedBuildInputs = [ urllib3 python-dateutil pytz future ];

  meta = with lib; {
    description = "Simple APIs to access any Amazon S3 compatible object storage server";
    homepage = "https://github.com/minio/minio-py";
    maintainers = with maintainers; [ peterromfeldhk ];
    license = licenses.asl20;
  };
}
