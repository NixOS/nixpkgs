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
  version = "1.15.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13b9ah54z6g3w8p74a1anmyz84nrxy27snqv6vp95wsizp8zwsyn";
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
