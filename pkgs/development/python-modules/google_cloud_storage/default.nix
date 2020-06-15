{ stdenv
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
  version = "1.28.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a7b5c326e7307a83fa1f1f0ef71aba9ad1f3a2bc6a768401e13fc02369fd8612";
  };

  propagatedBuildInputs = [
    google_resumable_media
    google_api_core
    google_cloud_core
    setuptools
  ];
  checkInputs = [ pytest mock ];

  # remove directory from interferring with importing modules
  # ignore tests which require credentials
  checkPhase = ''
    rm -r google
    pytest tests/unit -k 'not create'
  '';

  meta = with stdenv.lib; {
    description = "Google Cloud Storage API client library";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
