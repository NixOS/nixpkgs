{ stdenv
, buildPythonPackage
, fetchPypi
, google_resumable_media
, google_api_core
, google_cloud_core
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-storage";
  version = "1.13.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f8884619fed4c77234c7293939be5a696869f61a5dc2ca47193cff630cee179f";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ google_resumable_media google_api_core google_cloud_core ];

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
