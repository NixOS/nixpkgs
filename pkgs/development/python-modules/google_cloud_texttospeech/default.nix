{ stdenv
, buildPythonPackage
, fetchPypi
, google_api_core
, pytest
}:

buildPythonPackage rec {
  pname = "google-cloud-texttospeech";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6064bc6e2761694b708878ff3d5902c6ce5eb44a770a921e7a99caf6c2533ae3";
  };

  checkInputs = [ pytest ];
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
