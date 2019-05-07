{ stdenv, lib, buildPythonPackage, isPy3k, fetchPypi
, urllib3, python-dateutil , pytz, faker, mock, nose }:

buildPythonPackage rec {
  pname = "minio";
  version = "4.0.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "72c8ab7b1c25f875273e66762982816af8ada2ced88b6cd991e979f479c34875";
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
