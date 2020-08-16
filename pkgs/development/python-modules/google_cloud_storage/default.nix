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
  version = "1.30.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0634addb7576d48861d9963312fc82a0436042b8f282414ed58ca76d73edee54";
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
