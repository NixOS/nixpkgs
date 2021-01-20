{ lib, buildPythonPackage, isPy3k, fetchPypi
, configparser
, faker
, future
, mock
, nose
, python-dateutil
, pytz
, pytestCheckHook
, urllib3
}:

buildPythonPackage rec {
  pname = "minio";
  version = "6.0.2";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "acae9bfae0aec1b92025bd63e18135ebb4994c84600716c5323e14cb0c9a0b03";
  };

  propagatedBuildInputs = [
    configparser
    future
    python-dateutil
    pytz
    urllib3
  ];

  checkInputs = [ faker mock nose pytestCheckHook ];
  # example credentials aren't present
  pytestFlagsArray = [ "--ignore=tests/unit/credentials_test.py" ];

  meta = with lib; {
    description = "Simple APIs to access any Amazon S3 compatible object storage server";
    homepage = "https://github.com/minio/minio-py";
    maintainers = with maintainers; [ peterromfeldhk ];
    license = licenses.asl20;
  };
}
