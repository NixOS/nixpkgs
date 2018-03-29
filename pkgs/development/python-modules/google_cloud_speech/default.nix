{ stdenv, buildPythonPackage, fetchPypi
, setuptools, google_api_core, google_gax, google_cloud_core, pytest, mock }:

buildPythonPackage rec {
  pname = "google-cloud-speech";
  version = "0.32.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4f9a8ab3eb6630d0c0ca6ac15230dceba7d55d6707d162a84f255139ff780ee9";
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
