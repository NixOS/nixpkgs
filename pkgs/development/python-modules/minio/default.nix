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
, certifi
}:

buildPythonPackage rec {
  pname = "minio";
  version = "7.0.2";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f2f6022cfe4694d946972efef2a752f87d08cc030940faa50a640088772953c8";
  };

  propagatedBuildInputs = [
    configparser
    future
    python-dateutil
    pytz
    urllib3
    certifi
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
