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
  version = "1.9.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vMzZeoiWli3HjM8Dqr5RhNfR7gcjPqoXG3b/aNNlx2Q=";
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
