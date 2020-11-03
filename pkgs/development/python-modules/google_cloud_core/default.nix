{ stdenv, buildPythonPackage, fetchPypi, python
, google_api_core, grpcio, pytest, mock, setuptools }:

buildPythonPackage rec {
  pname = "google-cloud-core";
  version = "1.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "21afb70c1b0bce8eeb8abb5dca63c5fd37fc8aea18f4b6d60e803bd3d27e6b80";
  };

  requiredPythonModules = [ google_api_core grpcio setuptools ];
  checkInputs = [ pytest mock ];

  checkPhase = ''
    cd tests
    ${python.interpreter} -m unittest discover
  '';

  meta = with stdenv.lib; {
    description = "API Client library for Google Cloud: Core Helpers";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
