{ stdenv, buildPythonPackage, fetchPypi
, google_api_core, grpcio, pytest, mock }:

buildPythonPackage rec {
  pname = "google-cloud-core";
  version = "0.28.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "89e8140a288acec20c5e56159461d3afa4073570c9758c05d4e6cb7f2f8cc440";
  };

  propagatedBuildInputs = [ google_api_core grpcio ];
  checkInputs = [ pytest mock ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "API Client library for Google Cloud: Core Helpers";
    homepage = https://github.com/GoogleCloudPlatform/google-cloud-python;
    license = licenses.asl20;
    maintainers = with maintainers; [ vanschelven ];
  };
}
