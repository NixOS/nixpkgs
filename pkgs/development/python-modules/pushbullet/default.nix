{ lib, buildPythonPackage, fetchPypi
, requests, websocket_client, python_magic }:

buildPythonPackage rec {
  pname = "pushbullet.py";
  version = "0.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "537d3132e1dbc91e31ade4cccf4c7def6f9d48e904a67f341d35b8a54a9be74d";
  };

  propagatedBuildInputs = [ requests websocket_client python_magic ];

  meta = with lib; {
    description = "A simple python client for pushbullet.com";
    homepage = https://github.com/randomchars/pushbullet.py;
    license = licenses.mit;
  };
}
