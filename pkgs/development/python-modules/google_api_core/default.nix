{ stdenv, buildPythonPackage, fetchPypi
, google_auth, protobuf, googleapis_common_protos, requests, grpcio, setuptools, mock, pytest }:

buildPythonPackage rec {
  pname = "google-api-core";
  version = "0.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03bc4b1ab69c0e113af07e706edee50f583abe8219fe1e1d529dee191cb8e0bf";
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
