{ lib, buildPythonPackage, fetchFromGitHub, requests
, websocket_client, pythonOlder }:

buildPythonPackage rec {
  pname = "jellyfin-apiclient-python";
  version = "1.4.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "iwalton3";
    repo = "jellyfin-apiclient-python";
    rev = "v${version}";
    sha256 = "0b4ij19xjwn0wm5076fx8n4phjbsfx84x9qdrwm8c2r3ld8w7hk4";
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
