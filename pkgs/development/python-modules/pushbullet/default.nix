{ lib, buildPythonPackage, fetchPypi
, requests, websocket_client, python_magic
, pytest, mock }:

buildPythonPackage rec {
  pname = "pushbullet.py";
  version = "0.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aa9dc7bb46e083e3497d46241154f12944a8f540e29d150330ca94db0b453b8d";
  };

  propagatedBuildInputs = [ requests websocket_client python_magic ];

  checkInputs = [ pytest mock ];

  checkPhase = ''
    PUSHBULLET_API_KEY="" py.test -k "not test_e2e and not test_auth"
  '';

  meta = with lib; {
    description = "A simple python client for pushbullet.com";
    homepage = "https://github.com/randomchars/pushbullet.py";
    license = licenses.mit;
  };
}
