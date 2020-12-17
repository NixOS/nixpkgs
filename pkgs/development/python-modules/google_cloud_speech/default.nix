{ stdenv, buildPythonPackage, fetchPypi
, google_api_core, pytest, mock }:

buildPythonPackage rec {
  pname = "google-cloud-speech";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a7428190f4c10440148a273eb4c91480470b34180eec422b7325acdc0b2c0832";
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
