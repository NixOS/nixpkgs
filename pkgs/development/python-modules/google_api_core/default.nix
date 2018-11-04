{ lib, buildPythonPackage, fetchPypi, pythonOlder
, google_auth, protobuf, googleapis_common_protos, requests, grpcio, futures, mock, pytest }:

buildPythonPackage rec {
  pname = "google-api-core";
  version = "1.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7cf597628cb9c5ceb24834b30a325dc271d3ba15d868d81c20aa80a77e13be65";
  };

  propagatedBuildInputs = [
    googleapis_common_protos protobuf
    google_auth requests grpcio
  ] ++ lib.optional (pythonOlder "3.2") futures;
  checkInputs = [ mock pytest ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "This library is not meant to stand-alone. Instead it defines common helpers used by all Google API clients.";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ vanschelven ];
  };
}
