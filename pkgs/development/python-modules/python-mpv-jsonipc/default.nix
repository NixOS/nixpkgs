{ lib, buildPythonPackage, fetchFromGitHub, requests
, tqdm, websocket-client, pythonOlder }:

buildPythonPackage rec {
  pname = "python-mpv-jsonipc";
  version = "1.1.14";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "iwalton3";
    repo = "python-mpv-jsonipc";
    rev = "v${version}";
    sha256 = "sha256-kOC6FsLYTVx/cCL8AZuGkKarHqAESjJA+2BUagbiy3A=";
  };

  # 'mpv-jsonipc' does not have any tests
  doCheck = false;

  propagatedBuildInputs = [ requests tqdm websocket-client ];

  pythonImportsCheck = [ "python_mpv_jsonipc" ];

  meta = with lib; {
    homepage = "https://github.com/iwalton3/python-mpv-jsonipc";
    description = "Python API to MPV using JSON IPC";
    license = licenses.gpl3;
    maintainers = with maintainers; [ colemickens ];
  };
}
