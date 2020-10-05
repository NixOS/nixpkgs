{ stdenv, buildPythonPackage, fetchPypi, python
, google_api_core, grpcio, pytest, mock, setuptools }:

buildPythonPackage rec {
  pname = "google-cloud-core";
  version = "1.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a65d6485a8bc8d11ccb97d72a48213fa5d22012fb8779ef9f9d0dc1655fbd4fa";
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
