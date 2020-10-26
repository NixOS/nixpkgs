{ stdenv
, buildPythonPackage
, fetchPypi
, google_api_core
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-texttospeech";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cbbd397e72b6189668134f3c8e8c303198188334a4e6a5f77cc90c3220772f9e";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ google_api_core ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    broken = true;
    description = "Google Cloud Text-to-Speech API client library";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
