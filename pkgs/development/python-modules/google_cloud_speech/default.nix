{ stdenv, buildPythonPackage, fetchPypi
, google_api_core, pytest, mock }:

buildPythonPackage rec {
  pname = "google-cloud-speech";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d0ysapqrcwcyiil7nyh8vbj4i6hk9v23rrm4rdhgm0lwax7i0aj";
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
