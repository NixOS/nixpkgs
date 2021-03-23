{ lib
, buildPythonPackage
, fetchPypi
, google-auth
, googleapis-common-protos
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
  version = "1.25.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0e152ec37b8481d1be1258d95844a5a7031cd3d83d7c7046d9e9b2d807042440";
  };

  propagatedBuildInputs = [
    googleapis-common-protos
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
