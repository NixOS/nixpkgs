{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  tqdm,
  websocket-client,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "python-mpv-jsonipc";
  version = "1.2.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "iwalton3";
    repo = "python-mpv-jsonipc";
    rev = "v${version}";
    hash = "sha256-W9TNtbRhQmwZXhi0TJIDkZRtWhi92/iwL056YIcWnLM=";
  };

  # 'mpv-jsonipc' does not have any tests
  doCheck = false;

  propagatedBuildInputs = [
    requests
    tqdm
    websocket-client
  ];

  pythonImportsCheck = [ "python_mpv_jsonipc" ];

  meta = with lib; {
    homepage = "https://github.com/iwalton3/python-mpv-jsonipc";
    description = "Python API to MPV using JSON IPC";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
  };
}
