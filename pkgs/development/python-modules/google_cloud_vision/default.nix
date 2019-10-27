{ stdenv
, buildPythonPackage
, fetchPypi
, enum34
, google_api_core
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-vision";
  version = "0.39.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f33aea6721d453901ded268dee61a01ab77d4cd215a76edc3cc61b6028299d3e";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ enum34 google_api_core ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Cloud Vision API API client library";
    homepage = https://github.com/GoogleCloudPlatform/google-cloud-python;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
