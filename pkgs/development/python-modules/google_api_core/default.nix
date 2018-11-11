{ lib, buildPythonPackage, fetchPypi, pythonOlder
, google_auth, protobuf, googleapis_common_protos, requests, grpcio, futures, mock, pytest }:

buildPythonPackage rec {
  pname = "google-api-core";
  version = "1.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "383993eba1036c942f0d87497bac646b55ad8b4337d41527ce50e640768d769a";
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
