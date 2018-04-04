{ stdenv, buildPythonPackage, fetchPypi
, google_auth, protobuf3_5, googleapis_common_protos, requests, grpcio, setuptools, mock, pytest }:

buildPythonPackage rec {
  pname = "google-api-core";
  version = "0.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0144d467083ed54d2e8ccb4212d42c3724fe0b844b7d3a0ff85aea54b7ae8347";
  };

  propagatedBuildInputs = [ google_auth protobuf3_5 googleapis_common_protos requests grpcio ];
  checkInputs = [ setuptools mock pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "This library is not meant to stand-alone. Instead it defines common helpers used by all Google API clients.";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ vanschelven ];
  };
}
