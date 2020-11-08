{ lib, buildPythonPackage, fetchFromGitHub, requests
, websocket_client, pythonOlder }:

buildPythonPackage rec {
  pname = "jellyfin-apiclient-python";
  version = "1.6.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "iwalton3";
    repo = "jellyfin-apiclient-python";
    rev = "v${version}";
    sha256 = "0f7czq83ic22fz1vnf0cavb7l3grcxxd5yyw9wcjz3g1j2d76735";
  };

  requiredPythonModules = [ requests websocket_client ];

  pythonImportsCheck = [ "jellyfin_apiclient_python" ];

  meta = with lib; {
    homepage = "https://github.com/iwalton3/jellyfin-apiclient-python";
    description = "Python API client for Jellyfin";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jojosch ];
  };
}
