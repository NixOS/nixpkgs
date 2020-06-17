{ stdenv, buildPythonPackage, fetchPypi, python
, google_api_core, grpcio, pytest, mock, setuptools }:

buildPythonPackage rec {
  pname = "google-cloud-core";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1n19q57y4d89cjgmrg0f2a7yp7l1np2448mrhpndq354h389m3w7";
  };

  propagatedBuildInputs = [ google_api_core grpcio setuptools ];
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
