{ lib, buildPythonPackage, fetchFromGitHub, requests
, tqdm, websocket_client, pythonOlder }:

buildPythonPackage rec {
  pname = "python-mpv-jsonipc";
  version = "1.1.11";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "iwalton3";
    repo = "python-mpv-jsonipc";
    rev = "v${version}";
    sha256 = "034vc2j54dciiq80k7jn6kx4g7i58sjk0ykma039k5rihj2rblpk";
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
