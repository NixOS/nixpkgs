{ stdenv, buildPythonPackage, fetchPypi
, google_api_core, grpcio, pytest, mock }:

buildPythonPackage rec {
  pname = "google-cloud-core";
  version = "0.28.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1h8bx99ksla48zkb7bhkqy66b8prg49dp15alh851vzi9ii2zii7";
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
