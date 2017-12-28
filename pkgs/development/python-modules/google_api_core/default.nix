{ stdenv, buildPythonPackage, fetchPypi
, google_auth, protobuf, googleapis_common_protos, requests, grpcio, setuptools, mock, pytest }:

buildPythonPackage rec {
  pname = "google-api-core";
  version = "0.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qmjswj079w7q7zbnh8p4n2r3f831wymm9hfdlc7zfrini7184xv";
  };

  propagatedBuildInputs = [ google_auth protobuf googleapis_common_protos requests grpcio ];
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
