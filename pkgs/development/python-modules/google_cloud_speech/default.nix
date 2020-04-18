{ stdenv, buildPythonPackage, fetchPypi
, google_api_core, pytest, mock }:

buildPythonPackage rec {
  pname = "google-cloud-speech";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "21b597b18ee2b9b9a5e2e05a7a1d47173f8f3adeada36b5bdf6cb816114430bf";
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
