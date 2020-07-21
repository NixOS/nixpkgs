{ lib, buildPythonPackage, fetchPypi, pythonOlder, isPy27
, google_auth, protobuf, googleapis_common_protos, requests, setuptools, grpcio
, mock
}:

buildPythonPackage rec {
  pname = "google-api-core";
  version = "1.20.0";
  disabled = isPy27; # google namespace no longer works on python2

  src = fetchPypi {
    inherit pname version;
    sha256 = "eec2c302b50e6db0c713fb84b71b8d75cfad5dc6d4dffc78e9f69ba0008f5ede";
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
