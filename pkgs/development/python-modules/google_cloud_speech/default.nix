{ stdenv, buildPythonPackage, fetchPypi
, google_api_core, pytest, mock }:

buildPythonPackage rec {
  pname = "google-cloud-speech";
  version = "1.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2e5adbc0e88f296b1bc8667f1dcf26ca4ea2db6596f07cb0a39e7b1b8ef14656";
  };

  propagatedBuildInputs = [ google_api_core ];
  checkInputs = [ pytest mock ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Cloud Speech API enables integration of Google speech recognition into applications.";
    homepage = "https://github.com/googleapis/google-cloud-python/tree/master/speech";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
