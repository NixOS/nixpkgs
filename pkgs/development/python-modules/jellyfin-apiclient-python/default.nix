{
  lib,
  buildPythonPackage,
  certifi,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  requests,
  urllib3,
  websocket-client,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "jellyfin-apiclient-python";
  version = "1.10.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "jellyfin";
    repo = "jellyfin-apiclient-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-H1FqypNuVIZ17cFdNDEmmKICswxJkUGq2LhlingbCVk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    certifi
    requests
    urllib3
    websocket-client
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "jellyfin_apiclient_python" ];

  meta = with lib; {
    description = "Python API client for Jellyfin";
    homepage = "https://github.com/jellyfin/jellyfin-apiclient-python";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ jojosch ];
  };
}
