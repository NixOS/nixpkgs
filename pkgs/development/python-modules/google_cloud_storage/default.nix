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
  version = "1.23.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c66e876ae9547884fa42566a2ebfec51d280f488d7a058af9611ba90c78bed78";
  };

  propagatedBuildInputs = [
    google_resumable_media
    google_api_core
    google_cloud_core
    setuptools
  ];
  checkInputs = [ pytest mock ];

  checkPhase = ''
   pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Google Cloud Storage API client library";
    homepage = https://github.com/GoogleCloudPlatform/google-cloud-python;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
