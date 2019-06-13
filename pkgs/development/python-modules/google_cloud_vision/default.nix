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
  version = "0.35.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "25b537d4b76305e9758fe2f57fd5929a04bf3a46cb4e8d0f731e984f46405be8";
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
