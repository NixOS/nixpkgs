{ stdenv
, buildPythonPackage
, fetchPypi
, google_api_core
, pytest
, mock
}:

buildPythonPackage rec {
  pname = "google-cloud-texttospeech";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "75562a8db2b0268f57c64e448d697fe82c0ffa889f09be8cbc6ba5369c9a0c59";
  };

  checkInputs = [ pytest mock ];
  propagatedBuildInputs = [ google_api_core ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Google Cloud Text-to-Speech API client library";
    homepage = https://github.com/GoogleCloudPlatform/google-cloud-python;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
