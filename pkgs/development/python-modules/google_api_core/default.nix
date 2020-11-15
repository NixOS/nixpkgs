{ lib, buildPythonPackage, fetchPypi, pythonOlder, google_auth, protobuf
, googleapis_common_protos, requests, grpcio, mock, pytest, pytest-asyncio, pytestCheckHook }:

buildPythonPackage rec {
  pname = "google-api-core";
  version = "1.22.4";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06pck3hwl1pks26q843hv6pxchby9viab05mxf72k7ksab17m7aa";
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
