{ stdenv, buildPythonPackage, fetchPypi, python
, google_api_core, grpcio, pytest, mock, setuptools }:

buildPythonPackage rec {
  pname = "google-cloud-core";
  version = "1.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "613e56f164b6bee487dd34f606083a0130f66f42f7b10f99730afdf1630df507";
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
