{ stdenv, buildPythonPackage, fetchPypi
, setuptools, google_api_core, google_gax, google_cloud_core, pytest, mock }:

buildPythonPackage rec {
  pname = "google-cloud-speech";
  version = "0.34.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8396646aa9de210bacb144fabd82ab5fe577b3b11708725c879b72c96009d631";
  };

  propagatedBuildInputs = [ setuptools google_api_core google_gax google_cloud_core ];
  checkInputs = [ pytest mock ];

  # needs credentials
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Cloud Speech API enables integration of Google speech recognition into applications.";
    homepage = "https://googlecloudplatform.github.io/google-cloud-python/latest/speech/";
    license = licenses.asl20;
    maintainers = with maintainers; [ vanschelven ];
  };
}
