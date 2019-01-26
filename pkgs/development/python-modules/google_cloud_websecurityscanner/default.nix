{ stdenv
, buildPythonPackage
, fetchPypi
, google_api_core
, pytest
}:

buildPythonPackage rec {
  pname = "google-cloud-websecurityscanner";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d41a9e1a093862aa1b181fa7fdc2a94e185eb4a8f290dbdb928bc9ebd253a95f";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ google_api_core ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Google Cloud Web Security Scanner API client library";
    homepage = https://github.com/GoogleCloudPlatform/google-cloud-python;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
