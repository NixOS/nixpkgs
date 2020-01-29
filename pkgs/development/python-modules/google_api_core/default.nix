{ lib, buildPythonPackage, fetchPypi, pythonOlder, isPy27
, google_auth, protobuf, googleapis_common_protos, requests, setuptools, grpcio, futures, mock }:

buildPythonPackage rec {
  pname = "google-api-core";
  version = "1.15.0";
  disabled = isPy27; # google namespace no longer works on python2

  src = fetchPypi {
    inherit pname version;
    sha256 = "2d661c8d650a1df5805d0e360121cb55c55d8bd29f858fa62cbe943e59ce89f7";
  };

  propagatedBuildInputs = [
    googleapis_common_protos protobuf
    google_auth requests setuptools grpcio
  ] ++ lib.optional (pythonOlder "3.2") futures;

  # requires nox
  doCheck = false;
  checkInputs = [ mock ];

  pythonImportsCheck = [
    "google.auth"
    "google.protobuf"
    "google.api"
  ];

  meta = with lib; {
    description = "This library is not meant to stand-alone. Instead it defines common helpers used by all Google API clients.";
    homepage = "https://github.com/GoogleCloudPlatform/google-cloud-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ vanschelven ];
  };
}
