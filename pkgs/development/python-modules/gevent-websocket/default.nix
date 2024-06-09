{
  lib,
  buildPythonPackage,
  fetchPypi,
  gevent,
  gunicorn,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "gevent-websocket";
  version = "0.10.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fq7zKWgpDJEh98Nblz4swwL/sHbQGMkGjS9cqLLYX7A=";
  };

  propagatedBuildInputs = [
    gevent
    gunicorn
  ];

  # Module has no test
  doCheck = false;

  pythonImportsCheck = [ "geventwebsocket" ];

  meta = with lib; {
    description = "Websocket handler for the gevent pywsgi server";
    homepage = "https://www.gitlab.com/noppo/gevent-websocket";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
