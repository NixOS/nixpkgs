{ stdenv, lib, buildPythonPackage, isPy3k, fetchPypi
, urllib3, python-dateutil , pytz, faker, mock, nose }:

buildPythonPackage rec {
  pname = "minio";
  version = "4.0.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1sbmv1lskm5cs3jmn8f2688pimgibly16g8ycc6fgnsjanyby35l";
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
