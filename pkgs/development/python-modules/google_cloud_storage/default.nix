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
  version = "1.15.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8032e576e2f91a1d3de2355118040c3bcd9916e0453a6b3f64c1b42ed151690a";
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
