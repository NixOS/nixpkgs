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
  version = "1.14.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aef243b533144c11c9ff750565c43dffe5445debb143697002edb6205f64a437";
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
