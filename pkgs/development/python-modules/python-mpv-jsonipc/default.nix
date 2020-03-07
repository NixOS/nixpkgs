{ lib, buildPythonPackage, fetchFromGitHub, requests
, tqdm, websocket_client, pythonOlder }:

buildPythonPackage rec {
  pname = "python-mpv-jsonipc";
  version = "1.1.6";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "iwalton3";
    repo = "python-mpv-jsonipc";
    rev = "v${version}";
    sha256 = "08bs6qrcf5fi72jijmr2w7zs6aa5976dwv04f11ajwhj6i8kfq35";
  };

  # 'mpv-jsonipc' does not have any tests
  doCheck = false;

  propagatedBuildInputs = [ requests tqdm websocket_client ];

  pythonImportsCheck = [ "python_mpv_jsonipc" ];

  meta = with lib; {
    homepage = "https://github.com/iwalton3/python-mpv-jsonipc";
    description = "Python API to MPV using JSON IPC";
    license = licenses.gpl3;
    maintainers = with maintainers; [ colemickens ];
  };
}
