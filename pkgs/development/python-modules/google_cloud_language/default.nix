{ stdenv
, buildPythonPackage
, fetchPypi
, enum34
, google_api_core
, pytest
}:

buildPythonPackage rec {
  pname = "google-cloud-language";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2450e3265df129241cb21badb9d4ce2089d2652581df38e03c14a7ec85679ecb";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ enum34 google_api_core ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Google Cloud Natural Language API client library";
    homepage = https://github.com/GoogleCloudPlatform/google-cloud-python;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
