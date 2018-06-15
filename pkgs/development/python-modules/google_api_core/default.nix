{ lib, buildPythonPackage, fetchPypi, pythonOlder
, google_auth, protobuf, googleapis_common_protos, requests, grpcio, futures, mock, pytest }:

buildPythonPackage rec {
  pname = "google-api-core";
  version = "1.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2000963305e95410a66e6ef6cfcc9f4627a4a95cb1c10abc98268814f2a6cd80";
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
