{ stdenv, buildPythonPackage, fetchPypi
, google_api_core, pytest, mock }:

buildPythonPackage rec {
  pname = "google-cloud-speech";
  version = "0.35.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5db2d69315b3d95d067c9bffe17994b6ee9252702888cc300d76252b451638e1";
  };

  propagatedBuildInputs = [ google_api_core ];
  checkInputs = [ pytest mock ];

  # needs credentials
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Cloud Speech API enables integration of Google speech recognition into applications.";
    homepage = https://googlecloudplatform.github.io/google-cloud-python/latest/speech/;
    license = licenses.asl20;
    maintainers = with maintainers; [ vanschelven ];
  };
}
