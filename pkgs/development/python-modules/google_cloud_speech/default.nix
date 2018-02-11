{ stdenv, buildPythonPackage, fetchPypi
, setuptools, google_api_core, google_gax, google_cloud_core, pytest, mock }:

buildPythonPackage rec {
  pname = "google-cloud-speech";
  version = "0.31.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b0f6a542165750e42b1c92e6c465e8dc35c38d138ae7f08174971ab9b0df2a71";
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
