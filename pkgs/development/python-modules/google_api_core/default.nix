{ lib, buildPythonPackage, fetchPypi, pythonOlder, google_auth, protobuf
, googleapis_common_protos, requests, grpcio, mock, pytest, pytest-asyncio, pytestCheckHook }:

buildPythonPackage rec {
  pname = "google-api-core";
  version = "1.23.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bb3c485c38eacded8d685b1759968f6cf47dd9432922d34edb90359eaa391e2";
  };

  propagatedBuildInputs =
    [ googleapis_common_protos protobuf google_auth requests grpcio ];

  checkInputs = [ google_auth mock protobuf pytest-asyncio pytestCheckHook ];

  # prevent google directory from shadowing google imports
  preCheck = ''
    rm -r google
  '';

  pythonImportsCheck = [ "google.auth" "google.protobuf" "google.api" ];

  meta = with lib; {
    description = "Core Library for Google Client Libraries";
    longDescription = ''
      This library is not meant to stand-alone. Instead it defines common
      helpers used by all Google API clients.
    '';
    homepage = "https://github.com/googleapis/python-api-core";
    changelog =
      "https://github.com/googleapis/python-api-core/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
