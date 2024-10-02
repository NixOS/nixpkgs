{
  lib,
  buildPythonPackage,
  certifi,
  fetchPypi,
  pythonOlder,
  requests,
  urllib3,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "jellyfin-apiclient-python";
  version = "1.10.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5lifLotmALuWfgtYoPBlz0VhgjXmWYCme1eyN2V/IX4=";
  };

  propagatedBuildInputs = [
    certifi
    requests
    urllib3
    websocket-client
  ];

  # Module has no test
  doCheck = false;

  pythonImportsCheck = [ "jellyfin_apiclient_python" ];

  meta = with lib; {
    description = "Python API client for Jellyfin";
    homepage = "https://github.com/jellyfin/jellyfin-apiclient-python";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ jojosch ];
  };
}
