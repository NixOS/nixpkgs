{ stdenv, buildPythonPackage, fetchPypi
, google_api_core, pytest, mock }:

buildPythonPackage rec {
  pname = "google-cloud-speech";
  version = "0.36.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3d77da6086c01375908c8b800808ff83748a34b98313f885bd86df95448304fc";
  };

  propagatedBuildInputs = [ google_api_core ];
  checkInputs = [ pytest mock ];

  checkPhase = ''
    pytest tests/unit
  '';

  meta = with stdenv.lib; {
    description = "Cloud Speech API enables integration of Google speech recognition into applications.";
    homepage = "https://googlecloudplatform.github.io/google-cloud-python/latest/speech/";
    license = licenses.asl20;
    maintainers = with maintainers; [ vanschelven ];
  };
}
