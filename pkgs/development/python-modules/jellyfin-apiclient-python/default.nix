{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, requests
, six
, websocket-client
}:

buildPythonPackage rec {
  pname = "jellyfin-apiclient-python";
  version = "1.8.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-pH1mFm0enT8LOCYABAgb/T/ZwHyhtQGBu7mAxNeu7jQ=";
  };

  propagatedBuildInputs = [
    requests
    six
    websocket-client
  ];

  doCheck = false; # no tests
  pythonImportsCheck = [ "jellyfin_apiclient_python" ];

  meta = with lib; {
    homepage = "https://github.com/jellyfin/jellyfin-apiclient-python";
    description = "Python API client for Jellyfin";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ jojosch ];
  };
}
