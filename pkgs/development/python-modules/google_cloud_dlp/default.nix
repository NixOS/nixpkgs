{ stdenv
, buildPythonPackage
, fetchPypi
, enum34
, google_api_core
, pytest
}:

buildPythonPackage rec {
  pname = "google-cloud-dlp";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "408e5c6820dc53dd589a7bc378d25c2cf5817c448b7c7b1268bc745ecbe04ec3";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ enum34 google_api_core ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Cloud Data Loss Prevention (DLP) API API client library";
    homepage = https://github.com/GoogleCloudPlatform/google-cloud-python;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
