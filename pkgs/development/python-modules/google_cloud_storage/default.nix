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
  version = "1.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fc32b9be41a45016ba2387e3ad23e70ccba399d626ef596409316f7cee477956";
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
