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
  version = "1.30.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0724d354d394b3d763bc10dfee05807813c5210f0bd9b8e2ddf6b6925603411c";
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
