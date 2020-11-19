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
  version = "6.0.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "97d275ff01ddae45101eced0d9d5258f2869308c949b17d86a77b77a2a50b7b3";
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
