{ lib, buildPythonPackage, fetchPypi, pythonOlder, isPy27
, google_auth, protobuf, googleapis_common_protos, requests, setuptools, grpcio, mock }:

buildPythonPackage rec {
  pname = "google-api-core";
  version = "1.16.0";
  disabled = isPy27; # google namespace no longer works on python2

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qh30ji399gngv2j1czzvi3h0mgx3lfdx2n8qp8vii7ihyh65scj";
  };

  propagatedBuildInputs = [
    googleapis_common_protos protobuf
    google_auth requests setuptools grpcio
  ];

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
    maintainers = with maintainers; [ ];
  };
}
