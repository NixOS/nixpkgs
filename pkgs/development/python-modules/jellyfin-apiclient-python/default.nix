{ lib, buildPythonPackage, fetchPypi, requests
, websocket_client, pythonOlder }:

buildPythonPackage rec {
  pname = "jellyfin-apiclient-python";
  version = "1.6.2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-tFYMQYbnFTJTkZtJ+ZASWL6qsf/CK7EzTYukZm/wBgI=";
  };

  propagatedBuildInputs = [ requests websocket_client ];

  doCheck = false; # no tests
  pythonImportsCheck = [ "jellyfin_apiclient_python" ];

  meta = with lib; {
    homepage = "https://github.com/iwalton3/jellyfin-apiclient-python";
    description = "Python API client for Jellyfin";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jojosch ];
  };
}
