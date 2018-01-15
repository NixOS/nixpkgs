{ stdenv, buildPythonPackage, fetchPypi
, setuptools, google_api_core, google_gax, google_cloud_core, pytest, mock }:

buildPythonPackage rec {
  pname = "google-cloud-speech";
  version = "0.30.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ckigh6bfzhflhllqdnfygm8w0r6ncp0myf1midifx7sn880g4pa";
  };

  propagatedBuildInputs = [ setuptools google_api_core google_gax google_cloud_core ];
  checkInputs = [ pytest mock ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "Cloud Speech API enables integration of Google speech recognition into applications.";
    homepage = "https://googlecloudplatform.github.io/google-cloud-python/latest/speech/";
    license = licenses.asl20;
    maintainers = with maintainers; [ vanschelven ];
  };
}
