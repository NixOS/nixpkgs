{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, certifi
, requests
, six
, websocket-client
}:

buildPythonPackage rec {
  pname = "jellyfin-apiclient-python";
  version = "1.9.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-fS+NQUTKNxHuE+qsV91mpTlYt7DfXQVsA9ybfLlHYtc=";
  };

  propagatedBuildInputs = [
    certifi
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
