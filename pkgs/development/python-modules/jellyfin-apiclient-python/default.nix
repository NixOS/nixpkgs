{ lib, buildPythonPackage, fetchFromGitHub, requests
, websocket_client, pythonOlder }:

buildPythonPackage rec {
  pname = "jellyfin-apiclient-python";
  version = "1.5.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "iwalton3";
    repo = "jellyfin-apiclient-python";
    rev = "v${version}";
    sha256 = "1mzs4i9c4cf7pmymsyzs8x17hvjs8g9wr046l4f85rkzmz23v1rp";
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
