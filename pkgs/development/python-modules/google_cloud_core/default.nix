{ stdenv, buildPythonPackage, fetchPypi
, google_api_core, grpcio, pytest, mock }:

buildPythonPackage rec {
  pname = "google-cloud-core";
  version = "0.29.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d85b1aaaf3bad9415ad1d8ee5eadce96d7007a82f13ce0a0629a003a11e83f29";
  };

  propagatedBuildInputs = [ google_api_core grpcio ];
  checkInputs = [ pytest mock ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "API Client library for Google Cloud: Core Helpers";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ vanschelven ];
  };
}
