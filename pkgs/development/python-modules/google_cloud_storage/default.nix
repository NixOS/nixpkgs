{ lib
, buildPythonPackage
, fetchPypi
, google_resumable_media
, google_api_core
, google_cloud_core
, pytest
, mock
, setuptools
}:

buildPythonPackage rec {
  pname = "google-cloud-storage";
  version = "1.31.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "74bbb5b2d0b249de4a52f561435d0c3570ddc19b249653ae588ec0abcc3c81e6";
  };

  propagatedBuildInputs = [
    google_api_core
    google_cloud_core
    google_resumable_media
    setuptools
  ];
  checkInputs = [
    mock
    pytest
  ];

  # remove directory from interferring with importing modules
  # ignore tests which require credentials
  checkPhase = ''
    rm -r google
    pytest tests/unit -k 'not (create or get or post)'
  '';

  meta = with lib; {
    description = "Google Cloud Storage API client library";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ costrouc ];
  };
}
