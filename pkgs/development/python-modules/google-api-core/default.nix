{ lib
, buildPythonPackage
, fetchPypi
, google-auth
, googleapis_common_protos
, grpcio
, protobuf
, pytz
, requests
, mock
, pytest
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "google-api-core";
  version = "1.24.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0sflnpgsvk2h1cr1m3mgxx6pzz55xw7sk4y4qdimhs5jdm2fw78g";
  };

  propagatedBuildInputs = [
    googleapis_common_protos
    google-auth
    grpcio
    protobuf
    pytz
    requests
  ];

  checkInputs = [ mock pytest-asyncio pytestCheckHook ];

  # prevent google directory from shadowing google imports
  preCheck = ''
    rm -r google
  '';

  pythonImportsCheck = [ "google.api_core" ];

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
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
