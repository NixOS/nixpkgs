{ stdenv, buildPythonPackage, fetchPypi
, setuptools, google_api_core, google_gax, google_cloud_core, pytest, mock }:

buildPythonPackage rec {
  pname = "google-cloud-speech";
  version = "0.32.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2513725e693c3a2fdf22cb3065f3fcb39de2ab962a0cbc5de11a3889834189e1";
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
