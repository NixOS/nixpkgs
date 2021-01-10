{ lib, buildPythonPackage, fetchPypi, requests
, websocket_client, pythonOlder }:

buildPythonPackage rec {
  pname = "jellyfin-apiclient-python";
  version = "1.6.2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b4560c4186e7153253919b49f9901258beaab1ffc22bb1334d8ba4666ff00602";
  };

  propagatedBuildInputs = [ requests websocket_client ];

  pythonImportsCheck = [ "jellyfin_apiclient_python" ];

  meta = with lib; {
    homepage = "https://github.com/iwalton3/jellyfin-apiclient-python";
    description = "Python API client for Jellyfin";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jojosch ];
  };
}
