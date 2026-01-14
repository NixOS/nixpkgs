{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  tqdm,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "python-mpv-jsonipc";
  version = "1.2.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "iwalton3";
    repo = "python-mpv-jsonipc";
    rev = "v${version}";
    hash = "sha256-ugdLUmo5w+IbtmL2b6+la1X01mWNmnXr9j6e99oPWpE=";
  };

  # 'mpv-jsonipc' does not have any tests
  doCheck = false;

  propagatedBuildInputs = [
    requests
    tqdm
    websocket-client
  ];

  pythonImportsCheck = [ "python_mpv_jsonipc" ];

  meta = {
    homepage = "https://github.com/iwalton3/python-mpv-jsonipc";
    description = "Python API to MPV using JSON IPC";
    license = lib.licenses.gpl3;
    maintainers = [ ];
  };
}
