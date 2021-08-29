{ lib, buildPythonPackage, fetchPypi, requests
, websocket_client, pythonOlder }:

buildPythonPackage rec {
  pname = "jellyfin-apiclient-python";
  version = "1.7.2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-nSLUa9/jAT6XrHo77kV5HYBxPO/lhcWKqPfpES7ul9A=";
  };

  propagatedBuildInputs = [ requests websocket_client ];

  doCheck = false; # no tests
  pythonImportsCheck = [ "jellyfin_apiclient_python" ];

  meta = with lib; {
    homepage = "https://github.com/jellyfin/jellyfin-apiclient-python";
    description = "Python API client for Jellyfin";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ jojosch ];
  };
}
