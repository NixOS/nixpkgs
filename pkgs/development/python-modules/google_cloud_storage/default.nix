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
  version = "1.26.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0caxqf6vda89cmc81fxhmfk3n61aypqz2sswnbsylzf436rsxpzz";
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
    homepage = https://github.com/GoogleCloudPlatform/google-cloud-python;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
