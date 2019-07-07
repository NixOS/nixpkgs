{ lib, buildPythonPackage, fetchPypi, pythonOlder
, google_auth, protobuf, googleapis_common_protos, requests, grpcio, futures, mock, pytest }:

buildPythonPackage rec {
  pname = "google-api-core";
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "85693e163a1a6faea69a74f8feaf35d54dfa2559fbdbbe389c93ffb3bb4c9a79";
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
