{ lib
, buildPythonPackage
, fetchPypi
, google-auth
, googleapis-common-protos
, grpcio
, protobuf
, proto-plus
, requests
, mock
, pytest
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "google-api-core";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5ec27b942b34d04559cbf3674430bb83fc3d74e7d32b8bbd31c4466e71740b83";
  };

  propagatedBuildInputs = [
    googleapis-common-protos
    google-auth
    grpcio
    protobuf
    proto-plus
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
    changelog = "https://github.com/googleapis/python-api-core/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
