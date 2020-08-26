{ lib, buildPythonPackage, fetchPypi, pythonOlder, isPy27
, google_auth, protobuf, googleapis_common_protos, requests, setuptools, grpcio
, mock
}:

buildPythonPackage rec {
  pname = "google-api-core";
  version = "1.20.1";
  disabled = isPy27; # google namespace no longer works on python2

  src = fetchPypi {
    inherit pname version;
    sha256 = "6b757736bbc699db858794e9b71e2bbf17996075773a40551ef5e6b0fad2a2f9";
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
    description = "Core Library for Google Client Libraries";
    longDescription = ''
      This library is not meant to stand-alone. Instead it defines common
      helpers used by all Google API clients.
    '';
    homepage = "https://github.com/googleapis/python-api-core";
    changelog = "https://github.com/googleapis/python-api-core/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
